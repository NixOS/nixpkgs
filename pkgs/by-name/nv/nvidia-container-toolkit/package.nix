{ lib
, glibc
, fetchFromGitLab
, makeWrapper
, buildGoModule
, formats
, configTemplate ? null
, configTemplatePath ? null
, libnvidia-container
, autoAddDriverRunpath
}:

assert configTemplate != null -> (lib.isAttrs configTemplate && configTemplatePath == null);
assert configTemplatePath != null -> (lib.isStringLike configTemplatePath && configTemplate == null);

let
  configToml = if configTemplatePath != null then configTemplatePath else (formats.toml { }).generate "config.toml" configTemplate;

  # From https://gitlab.com/nvidia/container-toolkit/container-toolkit/-/blob/03cbf9c6cd26c75afef8a2dd68e0306aace80401/Makefile#L54
  cliVersionPackage = "github.com/NVIDIA/nvidia-container-toolkit/internal/info";
in
buildGoModule rec {
  pname = "container-toolkit/container-toolkit";
  version = "1.15.0-rc.3";

  src = fetchFromGitLab {
    owner = "nvidia";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IH2OjaLbcKSGG44aggolAOuJkjk+GaXnnTbrXfZ0lVo=";

  };

  outputs = [ "out" "tools" ];

  vendorHash = null;

  patches = [
    # This patch causes library lookups to first attempt loading via dlopen
    # before falling back to the regular symlink location and ldcache location.
    ./0001-Add-dlopen-discoverer.patch
  ];

  postPatch = ''
    # Replace the default hookDefaultFilePath to the $out path and override
    # default ldconfig locations to the one in nixpkgs.

    substituteInPlace internal/config/config.go \
      --replace '/usr/bin/nvidia-container-runtime-hook' "$out/bin/nvidia-container-runtime-hook" \
      --replace '/sbin/ldconfig' '${lib.getBin glibc}/sbin/ldconfig'

    substituteInPlace internal/config/config_test.go \
      --replace '/sbin/ldconfig' '${lib.getBin glibc}/sbin/ldconfig'

    substituteInPlace tools/container/toolkit/toolkit.go \
      --replace '/sbin/ldconfig' '${lib.getBin glibc}/sbin/ldconfig'

    substituteInPlace cmd/nvidia-ctk/hook/update-ldcache/update-ldcache.go \
      --replace '/sbin/ldconfig' '${lib.getBin glibc}/sbin/ldconfig'
  '';

  # Based on upstream's Makefile:
  # https://gitlab.com/nvidia/container-toolkit/container-toolkit/-/blob/03cbf9c6cd26c75afef8a2dd68e0306aace80401/Makefile#L64
  ldflags = [
    "-extldflags=-Wl,-z,lazy" # May be redunandant, cf. `man ld`: "Lazy binding is the default".
    "-s" # "disable symbol table"
    "-w" # "disable DWARF generation"

    # "-X name=value"
    "-X"
    "${cliVersionPackage}.version=${version}"
  ];

  nativeBuildInputs = [
    autoAddDriverRunpath
    makeWrapper
  ];

  checkFlags =
    let
      skippedTests = [
        # Disable tests executing nvidia-container-runtime command.
        "TestGoodInput"
        "TestDuplicateHook"
      ];
    in
    [ "-skip" "${builtins.concatStringsSep "|" skippedTests}" ];

  postInstall = ''
    wrapProgram $out/bin/nvidia-container-runtime-hook \
      --prefix PATH : ${libnvidia-container}/bin

    mkdir -p $tools/bin
    mv $out/bin/{containerd,crio,docker,nvidia-toolkit,toolkit} $tools/bin
  '' + lib.optionalString (configTemplate != null || configTemplatePath != null) ''
    mkdir -p $out/etc/nvidia-container-runtime

    cp ${configToml} $out/etc/nvidia-container-runtime/config.toml

    substituteInPlace $out/etc/nvidia-container-runtime/config.toml \
      --subst-var-by glibcbin ${lib.getBin glibc}
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/nvidia/container-toolkit/container-toolkit";
    description = "NVIDIA Container Toolkit";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cpcloud ];
  };
}
