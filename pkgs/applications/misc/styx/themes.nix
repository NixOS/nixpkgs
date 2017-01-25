{ fetchFromGitHub, stdenv }:

let

  mkThemeDrv = args: stdenv.mkDerivation {
    name = "styx-theme-${args.themeName}-${args.version}";

    src = fetchFromGitHub ({
      owner = "styx-static";
      repo = "styx-theme-${args.themeName}";
    } // args.src);

    installPhase = ''
      mkdir $out
      cp -r * $out/
    '';

    preferLocalBuild = true;

    meta = with stdenv.lib; {
      maintainer  = with maintainers; [ ericsagnes ];
      description = "${args.themeName} theme for styx";
      platforms   = platforms.all;
    } // args.meta;
  };

in
{
  agency = mkThemeDrv {
    themeName = "agency";
    version   = "2016-12-03";
    src = {
      rev    = "3604239cc5d940eee9c14ad2540d68a53cfebd7e";
      sha256 = "1kk8d5a3lb7fx1avivjd49gv0ffq7ppiswmwqlcsq87h2dbrqf61";
    };
    meta = {
      license = stdenv.lib.licenses.asl20;
      longDescription = ''
        Agency Theme is a one page portfolio for companies and freelancers.
        This theme features several content sections, a responsive portfolio
        grid with hover effects, full page portfolio item modals, a timeline,
        and a contact form.
      '';
    };
  };

  hyde = mkThemeDrv {
    themeName = "hyde";
    version   = "2016-12-03";
    src = {
      rev    = "b6b9b77839959fbf3c9ca3a4488617fa1831cd28";
      sha256 = "0d1k03mjn08s3rpc5rdivb8ahr345kblhqyihxnfgd1501ih9pg6";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
      longDescription = ''
        Hyde is a brazen two-column Jekyll theme that pairs a prominent sidebar
        with uncomplicated content.
      '';
    };
  };

  orbit = mkThemeDrv {
    themeName = "orbit";
    version   = "2016-12-03";
    src = {
      rev    = "1d41745c689c4336d4e2bfbb2483b80e67ec96e4";
      sha256 = "19pp9dykqxmrixn3cvqpdpcqy547y9n5izqhz0c4a11mmm0v3v64";
    };
    meta = {
      license = stdenv.lib.licenses.cc-by-30;
      longDescription = ''
        Orbit is a free resume/CV template designed for developers.
      '';
    };
  };

  showcase = mkThemeDrv {
    themeName = "showcase";
    version   = "2016-12-04";
    src = {
      rev    = "33feb0a09183e88d3580e9444ea36a255dffef60";
      sha256 = "01ighlnrja442ip5fhllydl77bfdz8yig80spmizivdfxdrdiyyf";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
      longDescription = ''
        Theme that show most of styx functionalities with a basic design.
      '';
    };
  };
}
