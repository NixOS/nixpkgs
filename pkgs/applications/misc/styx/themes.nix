{ fetchFromGitHub, stdenv }:

let

  mkThemeDrv = args: stdenv.mkDerivation {
    name = "styx-theme-${args.themeName}-${args.version}";

    src = fetchFromGitHub ({
      owner = "styx-static";
      repo  = "styx-theme-${args.themeName}";
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
  agency = mkThemeDrv rec {
    themeName = "agency";
    version   = "0.6.0";
    src = {
      rev    = "v${version}";
      sha256 = "1i9bajzgmxd3ffvgic6wwnqijsgkfr2mfdijkgw9yf3bxcdq5cb6";
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

  generic-templates = mkThemeDrv rec {
    themeName = "generic-templates";
    version   = "0.6.0";
    src = {
      rev    = "v${version}";
      sha256 = "0wr2687pffczn0sns1xvqxr2gpf5v9j64zbj6q9f7km6bq0zpiiy";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
    };
  };

  hyde = mkThemeDrv rec {
    themeName = "hyde";
    version   = "0.6.0";
    src = {
      rev    = "v${version}";
      sha256 = "0yca76p297ymxd049fkcpw8bca5b9yvv36707z31jbijriy50zxb";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
      longDescription = ''
        Port of the Jekyll Hyde theme to styx; Hyde is a brazen two-column
        Styx theme that pairs a prominent sidebar with uncomplicated content.
      '';
    };
  };

  orbit = mkThemeDrv rec {
    themeName = "orbit";
    version   = "0.6.0";
    src = {
      rev    = "v${version}";
      sha256 = "0qdx1r7dcycr5hzl9ix70pl4xf0426ghpi1lgh61zdpdhcch0xfi";
    };
    meta = {
      license = stdenv.lib.licenses.cc-by-30;
      longDescription = ''
        Orbit is a free resume/CV template designed for developers.
      '';
    };
  };

  showcase = mkThemeDrv rec {
    themeName = "showcase";
    version   = "0.6.0";
    src = {
      rev    = "v${version}";
      sha256 = "1jfhw49yag8l1zr69l01y1p4p88waig3xv3b6c3mfxc8jrchp7pb";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
      longDescription = ''
        Theme that show most of styx functionalities with a basic design.
      '';
    };
  };
}
