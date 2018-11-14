{ stdenv, lib, fetchFromGitHub, pkgconfig, asciidoc, docbook_xml_dtd_45
, docbook_xsl, libxslt, libxml2, makeWrapper
, dbus, libconfig, libdrm, libGL, pcre, libX11, libXcomposite, libXdamage
, libXinerama, libXrandr, libXrender, libXext, xwininfo }:

let
  common = source: stdenv.mkDerivation (source // rec {
    name = "${source.pname}-${source.version}";

    buildInputs = [
      dbus libX11 libXcomposite libXdamage libXrender libXrandr libXext
      libXinerama libdrm pcre libxml2 libxslt libconfig libGL
    ];

    nativeBuildInputs = [
      pkgconfig
      asciidoc
      docbook_xml_dtd_45
      docbook_xsl
      makeWrapper
    ];

    installFlags = [ "PREFIX=$(out)" ];

    postInstall = ''
      wrapProgram $out/bin/compton-trans \
        --prefix PATH : ${lib.makeBinPath [ xwininfo ]}
    '';

    meta = with lib; {
      description = "A fork of XCompMgr, a sample compositing manager for X servers";
      longDescription = ''
        A fork of XCompMgr, which is a sample compositing manager for X
        servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
        extensions. It enables basic eye-candy effects. This fork adds
        additional features, such as additional effects, and a fork at a
        well-defined and proper place.
      '';
      license = licenses.mit;
      maintainers = with maintainers; [ ertes enzime twey ];
      platforms = platforms.linux;
    };
  });

  stableSource = rec {
    pname = "compton";
    version = "0.1_beta2.5";

    COMPTON_VERSION = version;

    src = fetchFromGitHub {
      owner = "chjj";
      repo = "compton";
      rev = "b7f43ee67a1d2d08239a2eb67b7f50fe51a592a8";
      sha256 = "1p7ayzvm3c63q42na5frznq3rlr1lby2pdgbvzm1zl07wagqss18";
    };

    meta = {
      homepage = https://github.com/chjj/compton/;
    };
  };

  gitSource = rec {
    pname = "compton-git";
    version = "2";

    COMPTON_VERSION = "v${version}";

    src = fetchFromGitHub {
      owner  = "yshui";
      repo   = "compton";
      rev    = COMPTON_VERSION;
      sha256 = "1b6jgkkjbmgm7d7qjs94h722kgbqjagcxznkh2r84hcmcl8pibjq";
    };

    meta = {
      homepage = https://github.com/yshui/compton/;
    };
  };
in {
  compton = common stableSource;
  compton-git = common gitSource;
}
