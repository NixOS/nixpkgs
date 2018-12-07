{ stdenv, fetchFromGitHub, octoprint, python2Packages }:

let
  buildPlugin = args: python2Packages.buildPythonPackage (args // {
    propagatedBuildInputs = (args.propagatedBuildInputs or []) ++ [ octoprint ];
    # none of the following have tests
    doCheck = false;
  });

  self = {

    # Deprecated alias
    m3d-fio = self.m33-fio; # added 2016-08-13

    m33-fio = buildPlugin rec {
      name = "M33-Fio-${version}";
      version = "1.21";

      src = fetchFromGitHub {
        owner = "donovan6000";
        repo = "M33-Fio";
        rev = "V${version}";
        sha256 = "1la3611kkqn8yiwjn6cizc45ri8pnk6ckld1na4nk6mqk88jvjq7";
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
        homepage = https://github.com/donovan6000/M33-Fio;
        description = "OctoPrint plugin for the Micro 3D printer";
        platforms = platforms.all;
        license = licenses.gpl3;
        maintainers = with maintainers; [ abbradar ];
      };
    };

    mqtt = buildPlugin rec {
      name = "OctoPrint-MQTT-${version}";
      version = "0.8.0";

      src = fetchFromGitHub {
        owner = "OctoPrint";
        repo = "OctoPrint-MQTT";
        rev = version;
        sha256 = "1318pgwy39gkdqgll3q5lwm7avslgdwyiwb5v8m23cgyh5w8cjq7";
      };

      propagatedBuildInputs = with python2Packages; [ paho-mqtt ];

      meta = with stdenv.lib; {
        homepage = https://github.com/OctoPrint/OctoPrint-MQTT;
        description = "Publish printer status MQTT";
        platforms = platforms.all;
        license = licenses.agpl3;
        maintainers = with maintainers; [ peterhoeg ];
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
      version = "0.4.1";

      src = fetchFromGitHub {
        owner = "jneilliii";
        repo = "OctoPrint-STLViewer";
        rev = "v${version}";
        sha256 = "1f64s37g2d79g76v0vjnjrc2jp2gwrsnfgx7w3n0hkf1lz1pjkm0";
      };

      meta = with stdenv.lib; {
        homepage = https://github.com/jneilliii/Octoprint-STLViewer;
        description = "A simple stl viewer tab for OctoPrint";
        platforms = platforms.all;
        license = licenses.agpl3;
        maintainers = with maintainers; [ abbradar ];
      };
    };

  };

in self
