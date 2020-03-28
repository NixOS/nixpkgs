{ appimageTools, fetchurl, writeTextFile, lib }:
let
  version = "1.5.0";
  tandemApp = appimageTools.wrapType2 {
    name = "tandem";
    src = fetchurl {
      url = "https://tandem-app.sfo2.cdn.digitaloceanspaces.com/Tandemx86_64${version}.AppImage";
      sha256 = "0xg0vzznqvq38zwdq32d9ryliwfpss1qigprx7jd9kpswknx90w8";
    };
    extraPkgs = pkgs: [ pkgs.at-spi2-core ];
  };
in with lib; addMetaAttrs {
    description = "A virtual office for remote teams";
    homepage = https://tandem.chat;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.chpatrick ];
  }
  (writeTextFile {
    name = "tandem-${version}";
    executable = true;
    destination = "/bin/tandem";
    # TODO: Without this, tandem fails with:
    # The SUID sandbox helper binary was found, but is not configured correctly. Rather than run without sandboxing I'm aborting now. You need to make sure that .../tandem-extracted/chrome-sandbox is owned by root and has mode 4755.
    # Ideally this would use the Chromium sandbox somehow.
    text = ''
      #!/usr/bin/env bash
      ${tandemApp}/bin/tandem --no-sandbox "$@"
    '';
  })