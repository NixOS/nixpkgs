{ lib
, buildGoPackage
, fetchFromGitHub
, version
, sha256
, nvidiaGpuSupport
, patchelf
, nvidia_x11
}:

buildGoPackage rec {
  pname = "nomad";
  inherit version;
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/nomad";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    inherit rev sha256;
  };

  nativeBuildInputs = lib.optionals nvidiaGpuSupport [
    patchelf
  ];

  # ui:
  #  Nomad release commits include the compiled version of the UI, but the file
  #  is only included if we build with the ui tag.
  tags = [ "ui" ] ++ lib.optional (!nvidiaGpuSupport) "nonvidia";

  # The dependency on NVML isn't explicit. We have to make it so otherwise the
  # binary will not know where to look for the relevant symbols.
  postFixup = lib.optionalString nvidiaGpuSupport ''
    for bin in $out/bin/*; do
      patchelf --add-needed "${nvidia_x11}/lib/libnvidia-ml.so" "$bin"
    done
  '';

  meta = with lib; {
    homepage = "https://www.nomadproject.io/";
    description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
    platforms = platforms.unix;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem pradeepchhetri endocrimes maxeaubrey ];
  };
}
