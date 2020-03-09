{ stdenv, fetchgit, fetchFromGitHub, octoprint, python2Packages, marlin-calc }:

let
  buildPlugin = args: python2Packages.buildPythonPackage (args // {
    pname = "OctoPrintPlugin-${args.pname}";
    inherit (args) version;
    propagatedBuildInputs = (args.propagatedBuildInputs or []) ++ [ octoprint ];
    # none of the following have tests
    doCheck = false;
  });

  self = {

    # Deprecated alias
    m3d-fio = self.m33-fio; # added 2016-08-13

    m33-fio = buildPlugin rec {
      pname = "M33-Fio";
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
        description = "OctoPrint plugin for the Micro 3D printer";
        homepage = https://github.com/donovan6000/M33-Fio;
        license = licenses.gpl3;
        maintainers = with maintainers; [ abbradar ];
      };
    };

    mqtt = buildPlugin rec {
      pname = "MQTT";
      version = "0.8.6";

      src = fetchFromGitHub {
        owner = "OctoPrint";
        repo = "OctoPrint-MQTT";
        rev = version;
        sha256 = "0y1jnfplcy8mh3szrfbbvngl02j49cbdizglrfsry4fvqg50zjxd";
      };

      propagatedBuildInputs = with python2Packages; [ paho-mqtt ];

      meta = with stdenv.lib; {
        description = "Publish printer status MQTT";
        homepage = https://github.com/OctoPrint/OctoPrint-MQTT;
        license = licenses.agpl3;
        maintainers = with maintainers; [ peterhoeg ];
      };
    };

    titlestatus = buildPlugin rec {
      pname = "TitleStatus";
      version = "0.0.4";

      src = fetchFromGitHub {
        owner = "MoonshineSG";
        repo = "OctoPrint-TitleStatus";
        rev = version;
        sha256 = "1l78xrabn5hcly2mgxwi17nwgnp2s6jxi9iy4wnw8k8icv74ag7k";
      };

      meta = with stdenv.lib; {
        description = "Show printers status in window title";
        homepage = https://github.com/MoonshineSG/OctoPrint-TitleStatus;
        license = licenses.agpl3;
        maintainers = with maintainers; [ abbradar ];
      };
    };

    stlviewer = buildPlugin rec {
      pname = "STLViewer";
      version = "0.4.2";

      src = fetchFromGitHub {
        owner = "jneilliii";
        repo = "OctoPrint-STLViewer";
        rev = version;
        sha256 = "0mkvh44fn2ch4z2avsdjwi1rp353ylmk9j5fln4x7rx8ph8y7g2b";
      };

      meta = with stdenv.lib; {
        description = "A simple stl viewer tab for OctoPrint";
        homepage = https://github.com/jneilliii/Octoprint-STLViewer;
        license = licenses.agpl3;
        maintainers = with maintainers; [ abbradar ];
      };
    };

    curaenginelegacy = buildPlugin rec {
      pname = "CuraEngineLegacy";
      version = "1.0.2";

      src = fetchFromGitHub {
        owner = "OctoPrint";
        repo = "OctoPrint-${pname}";
        rev = version;
        sha256 = "1cdb276wfyf3wcfj5g3migd6b6aqmkrxncrqjfcfx4j4k3xac965";
      };

      meta = with stdenv.lib; {
        description = "Plugin for slicing via Cura Legacy from within OctoPrint";
        homepage = "https://github.com/OctoPrint/OctoPrint-CuraEngineLegacy";
        license = licenses.agpl3;
        maintainers = with maintainers; [ gebner ];
      };
    };

    touchui = buildPlugin rec {
      pname = "TouchUI";
      version = "0.3.13";

      src = fetchFromGitHub {
        owner = "BillyBlaze";
        repo = "OctoPrint-${pname}";
        rev = version;
        sha256 = "0qk12ysabdzy6cna3l4f8v3qcnppppwxxsjx2i0xn1nd0cv6yzwh";
      };

      meta = with stdenv.lib; {
        description = "Touch friendly interface for a small TFT module or phone for OctoPrint";
        homepage = "https://github.com/BillyBlaze/OctoPrint-TouchUI";
        license = licenses.agpl3;
        maintainers = with maintainers; [ gebner ];
      };
    };

    psucontrol = buildPlugin rec {
      pname = "PSUControl";
      version = "0.1.8";

      src = fetchFromGitHub {
        owner = "kantlivelong";
        repo = "OctoPrint-${pname}";
        rev = version;
        sha256 = "0aj38d7b7d5pzmzq841pip18cpg18wy2vrxq2nd13875597y54b8";
      };

      preConfigure = ''
        # optional; RPi.GPIO is broken on vanilla kernels
        sed /RPi.GPIO/d -i requirements.txt
      '';

      meta = with stdenv.lib; {
        description = "OctoPrint plugin to control ATX/AUX power supply";
        homepage = "https://github.com/kantlivelong/OctoPrint-PSUControl";
        license = licenses.agpl3;
        maintainers = with maintainers; [ gebner ];
      };
    };

    printtimegenius = buildPlugin rec {
      pname = "PrintTimeGenius";
      version = "2.2.1";

      src = fetchFromGitHub {
        owner = "eyal0";
        repo = "OctoPrint-${pname}";
        rev = version;
        sha256 = "1dr93vbpxgxw3b1q4rwam8f4dmiwr5vnfr9796g6jx8xkpfzzy1h";
      };

      preConfigure = ''
        # PrintTimeGenius ships with marlin-calc binaries for multiple architectures
        rm */analyzers/marlin-calc*
        sed 's@"{}.{}".format(binary_base_name, machine)@"${marlin-calc}/bin/marlin-calc"@' -i */analyzers/analyze_progress.py
      '';

      patches = [
        ./printtimegenius-logging.patch
      ];

      meta = with stdenv.lib; {
        description = "Better print time estimation for OctoPrint";
        homepage = "https://github.com/eyal0/OctoPrint-PrintTimeGenius";
        license = licenses.agpl3;
        maintainers = with maintainers; [ gebner ];
      };
    };

    abl-expert = buildPlugin rec {
      pname = "ABL_Expert";
      version = "2019-12-21";

      src = fetchgit {
        url = "https://framagit.org/razer/Octoprint_ABL_Expert/";
        rev = "f11fbe05088ad618bfd9d064ac3881faec223f33";
        sha256 = "026r4prkyvwzxag5pv36455q7s3gaig37nmr2nbvhwq3d2lbi5s4";
      };

      meta = with stdenv.lib; {
        description = "Marlin auto bed leveling control, mesh correction, and z probe handling";
        homepage = "https://framagit.org/razer/Octoprint_ABL_Expert/";
        license = licenses.agpl3;
        maintainers = with maintainers; [ WhittlesJr ];
      };
    };

    gcodeeditor = buildPlugin rec {
      pname = "GcodeEditor";
      version = "0.2.6";

      src = fetchFromGitHub {
        owner = "ieatacid";
        repo = "OctoPrint-${pname}";
        rev = version;
        sha256 = "0c6p78r3vd6ys3kld308pyln09zjbr9yif1ljvcx6wlml2i5l1vh";
      };

      meta = with stdenv.lib; {
        description = "Edit gcode on OctoPrint";
        homepage = "https://github.com/Sebclem/OctoPrint-SimpleEmergencyStop";
        license = licenses.agpl3;
        maintainers = with maintainers; [ WhittlesJr ];
      };
    };

    simpleemergencystop = buildPlugin rec {
      pname = "SimpleEmergencyStop";
      version = "0.2.5";

      src = fetchFromGitHub {
        owner = "Sebclem";
        repo = "OctoPrint-${pname}";
        rev = version;
        sha256 = "10wadv09wv2h96igvq3byw9hz1si82n3c7v5y0ii3j7hm2d06y8p";
      };

      meta = with stdenv.lib; {
        description = "A simple plugin that add an emergency stop buton on NavBar of OctoPrint";
        homepage = "https://github.com/ieatacid/OctoPrint-GcodeEditor";
        license = licenses.agpl3;
        maintainers = with maintainers; [ WhittlesJr ];
      };
    };
  };

in self
