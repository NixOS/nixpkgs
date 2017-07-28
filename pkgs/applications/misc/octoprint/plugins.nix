{ stdenv, fetchFromGitHub, fetchpatch, octoprint, pythonPackages }:

let
  buildPlugin = args: pythonPackages.buildPythonApplication (args // {
    buildInputs = (args.buildInputs or []) ++ [ octoprint ];
  });

  self = {

    # Deprecated alias
    m3d-fio = self.m33-fio; # added 2016-08-13

    m33-fio = buildPlugin rec {
      name = "M33-Fio-${version}";
      version = "1.20";

      src = fetchFromGitHub {
        owner = "donovan6000";
        repo = "M33-Fio";
        rev = "V${version}";
        sha256 = "1ng7lzlkqsjcr1w7wgzwsqkkvcvpajcj2cwqlffh95916sw8n767";
      };

      patches = [
        ./m33-fio-one-library.patch
      ];

      postPatch = ''
        rm -rf octoprint_m33fio/static/libraries/*
        (
          cd 'shared library source'
          make
        )
      '';

      meta = with stdenv.lib; {
        homepage = "https://github.com/donovan6000/M33-Fio";
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
        homepage = "https://github.com/MoonshineSG/OctoPrint-TitleStatus";
        description = "Show printers status in window title";
        platforms = platforms.all;
        license = licenses.agpl3;
        maintainers = with maintainers; [ abbradar ];
      };
    };

    stlviewer = buildPlugin rec {
      name = "OctoPrint-STLViewer-${version}";
      version = "0.4.1";

      src = fetchFromGitHub {
        owner = "jneilliii";
        repo = "OctoPrint-STLViewer";
        rev = "v${version}";
        sha256 = "1f64s37g2d79g76v0vjnjrc2jp2gwrsnfgx7w3n0hkf1lz1pjkm0";
      };

      meta = with stdenv.lib; {
        homepage = "https://github.com/jneilliii/Octoprint-STLViewer";
        description = "A simple stl viewer tab for OctoPrint";
        platforms = platforms.all;
        license = licenses.agpl3;
        maintainers = with maintainers; [ abbradar ];
      };
    };

  };

in self
