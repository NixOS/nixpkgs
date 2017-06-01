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
      version = "1.17";

      src = fetchFromGitHub {
        owner = "donovan6000";
        repo = "M33-Fio";
        rev = "V${version}";
        sha256 = "19r860hqax09a79s9bl181ab7jsgx0pa8fvnr62lbgkwhis7m8mh";
      };

      patches = [
        ./m33-fio-one-library.patch
        # Fix incompatibility with new OctoPrint
        (fetchpatch {
          url = "https://github.com/foosel/M33-Fio/commit/bdf2422dee3fb8e53b33f087f734956c3b209d72.patch";
          sha256 = "0jm415sx6d3m0z4gfhbnxlasg08zf3f3mslaj4amn9wbvsik9s5d";
        })
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
      version = "0.3.0";

      src = fetchFromGitHub {
        owner = "jneilliii";
        repo = "OctoPrint-STLViewer";
        rev = "v${version}";
        sha256 = "1a6sa8pw9ay7x27pfwr3nzb22x3jaw0c9vwyz4mrj76zkiw6svfi";
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
