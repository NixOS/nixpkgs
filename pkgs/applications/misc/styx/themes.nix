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
  agency = mkThemeDrv {
    themeName = "agency";
    version   = "2017-01-17";
    src = {
      rev    = "3201f65841c9e7f97cc0ab0264cafb01b1620ed7";
      sha256 = "1b3547lzmhs1lmr9gln1yvh5xrsg92m8ngrjwf0ny91y81x04da6";
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

  generic-templates = mkThemeDrv {
    themeName = "generic-templates";
    version   = "2017-01-18";
    src = {
      rev    = "af7cd527584322d8731a306a137a1794b18ad71a";
      sha256 = "18zk4qihi8iw5dxkm9sf6cjai1mf22l6q1ykkrgaxjd5709is0li";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
    };
  };

  hyde = mkThemeDrv {
    themeName = "hyde";
    version   = "2017-01-17";
    src = {
      rev    = "22caf4edc738f399bb1013d8e968d111c7fa2a59";
      sha256 = "1a2j3m941vc2pyb1dz341ww5l3xblg527szfrfqh588lmsrkdqb6";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
      longDescription = ''
        Port of the Jekyll Hyde theme to styx; Hyde is a brazen two-column
        Styx theme that pairs a prominent sidebar with uncomplicated content.
      '';
    };
  };

  orbit = mkThemeDrv {
    themeName = "orbit";
    version   = "2017-01-17";
    src = {
      rev    = "b5896e25561f05e026b34d04ad95a647ddfc3d03";
      sha256 = "11p11f2d0swgjil5hfx153yw13p7pcp6fwx1bnvxrlfmmx9x2yj5";
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
    version   = "2017-01-17";
    src = {
      rev    = "1b4b9d4af29c05aaadfd58233f0e3f61fac726af";
      sha256 = "0mwd1ycwvlv15y431336wwlv8mdv0ikz1aymh3yxhjyxqllc2snk";
    };
    meta = {
      license = stdenv.lib.licenses.mit;
      longDescription = ''
        Theme that show most of styx functionalities with a basic design.
      '';
    };
  };
}
