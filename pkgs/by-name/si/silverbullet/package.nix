{ lib, stdenv, fetchurl, deno }:
stdenv.mkDerivation rec {
  name = "silverbullet";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/silverbulletmd/silverbullet/releases/download/${version}/${name}.js";
    sha256 = "sha256-QBxmSsR4YvBCPPyVAX73fFAERMcIaUwpdllA/z2iWTc=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/silverbullet.js
    cat > $out/bin/silverbullet <<EOF
    #!/usr/bin/env sh
    exec ${deno}/bin/deno run -A --unstable $out/bin/silverbullet.js \$@
    EOF
    chmod +x $out/bin/silverbullet
  '';

  meta = with lib; {
    description = "An open-source, self-hosted, offline-capable Personal Knowledge Management (PKM) web application";
    homepage = "https://silverbullet.md/";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "silverbullet";
    maintainers = with lib.maintainers; [ devzero ];
    downloadPage = "https://github.com/silverbulletmd/silverbullet/releases";
  };
}
