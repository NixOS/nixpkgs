{
  lib,
  stdenvNoCC,
  fetchzip,
  runtimeShell,
  bashInteractive,
  glibcLocales,
}:

stdenvNoCC.mkDerivation {
  pname = "blesh";
  version = "0.4.0-devel3-unstable-2026-03-10";

  src = fetchzip {
    url = "https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly-20260310%2Bb99cadb.tar.xz";
    name = "ble-nightly-20260310+b99cadb.tar.xz";
    sha256 = "sha256-rJnSEY7J4wfy8dnL9Bg59u0epPe0HL1J7piPbkNyes0=";
  };

  dontBuild = true;

  doCheck = true;
  nativeCheckInputs = [
    bashInteractive
    glibcLocales
  ];
  preCheck = "export LC_ALL=en_US.UTF-8";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/blesh/lib"

    cat <<EOF >"$out/share/blesh/lib/_package.sh"
    _ble_base_package_type=nix

    function ble/base/package:nix/update {
      echo "Ble.sh is installed by Nix. You can update it there." >&2
      return 1
    }
    EOF

    cp -rv $src/* $out/share/blesh

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p "$out/bin"
    cat <<EOF >"$out/bin/blesh-share"
    #!${runtimeShell}
    # Run this script to find the ble.sh shared folder
    # where all the shell scripts are living.
    echo "$out/share/blesh"
    EOF
    chmod +x "$out/bin/blesh-share"
  '';

  meta = {
    homepage = "https://github.com/akinomyoga/ble.sh";
    description = "Bash Line Editor -- a full-featured line editor written in pure Bash";
    mainProgram = "blesh-share";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      aiotter
      hibiday
      matthiasbeyer
    ];
    platforms = lib.platforms.unix;
  };
}
