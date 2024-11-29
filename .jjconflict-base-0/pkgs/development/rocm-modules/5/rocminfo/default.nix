{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, rocm-runtime
, busybox
, python3
, gnugrep
  # rocminfo requires that the calling user have a password and be in
  # the video group. If we let rocm_agent_enumerator rely upon
  # rocminfo's output, then it, too, has those requirements. Instead,
  # we can specify the GPU targets for this system (e.g. "gfx803" for
  # Polaris) such that no system call is needed for downstream
  # compilers to determine the desired target.
, defaultTargets ? []
}:

stdenv.mkDerivation (finalAttrs: {
  version = "5.7.1";
  pname = "rocminfo";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocminfo";
    rev = "rocm-${finalAttrs.version}";
    sha256 = "sha256-UzOo2qDT/uM+vdGdBM4pV5e143mfa+/6sZLBExOO26g=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  buildInputs = [ rocm-runtime ];
  propagatedBuildInputs = [ python3 ];
  cmakeFlags = [ "-DROCRTST_BLD_TYPE=Release" ];

  prePatch = ''
    patchShebangs rocm_agent_enumerator
    sed 's,lsmod | grep ,${busybox}/bin/lsmod | ${gnugrep}/bin/grep ,' -i rocminfo.cc
  '';

  postInstall = lib.optionalString (defaultTargets != [ ]) ''
    echo '${lib.concatStringsSep "\n" defaultTargets}' > $out/bin/target.lst
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm Application for Reporting System Info";
    homepage = "https://github.com/ROCm/rocminfo";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = stdenv.hostPlatform.isAarch64 || versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "6.0.0";
  };
})
