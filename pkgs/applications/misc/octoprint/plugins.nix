{ stdenv, fetchFromGitHub, octoprint, pythonPackages }:

let
  buildPlugin = args: pythonPackages.buildPythonApplication (args // {
    buildInputs = (args.buildInputs or []) ++ [ octoprint ];
  });
in {

  m3d-fio = buildPlugin rec {
    name = "M3D-Fio-${version}";
    version = "0.30.2";

    src = fetchFromGitHub {
      owner = "donovan6000";
      repo = "M3D-Fio";
      rev = "V${version}";
      sha256 = "1knm41hwjf6v4yjx8khr2zd9ryndmw8bkp3y80hgjc5p4nqxrmg3";
    };

    patches = [
      ./0001-Don-t-use-static-library.patch
    ];

    postInstall = ''
    (
      cd 'shared library source'
      make
      install -Dm755 libpreprocessor.so $out/lib/libpreprocessor.so
    )
    rm -rf $out/${pythonPackages.python.sitePackages}/octoprint_m3dfio/static/libraries
    '';

    meta = with stdenv.lib; {
      homepage = "https://github.com/donovan6000/M3D-Fio";
      description = "OctoPrint plugin for the Micro 3D printer";
      platforms = platforms.all;
      license = licenses.gpl3;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  titlestatus = buildPlugin rec {
    name = "OctoPrint-TitleStatus-${version}";
    version = "0.0.4";

    src = fetchFromGitHub {
      owner = "MoonshineSG";
      repo = "OctoPrint-TitleStatus";
      rev = version;
      sha256 = "1l78xrabn5hcly2mgxwi17nwgnp2s6jxi9iy4wnw8k8icv74ag7k";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/MoonshineSG/OctoPrint-TitleStatus;
      description = "Show printers status in window title";
      platforms = platforms.all;
      license = licenses.agpl3;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  stlviewer = buildPlugin rec {
    name = "OctoPrint-STLViewer-${version}";
    version = "0.3.0";

    src = fetchFromGitHub {
      owner = "jneilliii";
      repo = "OctoPrint-STLViewer";
      rev = "v${version}";
      sha256 = "1a6sa8pw9ay7x27pfwr3nzb22x3jaw0c9vwyz4mrj76zkiw6svfi";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/jneilliii/Octoprint-STLViewer;
      description = "A simple stl viewer tab for OctoPrint";
      platforms = platforms.all;
      license = licenses.agpl3;
      maintainers = with maintainers; [ abbradar ];
    };
  };

}
