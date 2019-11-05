{ stdenv, fetchFromGitHub, octoprint, python2Packages, marlin-calc }:

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
      version = "2.0.2";

      src = fetchFromGitHub {
        owner = "eyal0";
        repo = "OctoPrint-${pname}";
        rev = version;
        sha256 = "1w4jm42434x87sbih45brkb9krik851vxkz153w3w5c8p74kgg6f";
      };

      preConfigure = ''
        # PrintTimeGenius ships with marlin-calc binaries for multiple architectures
        rm */analyzers/marlin-calc*
        sed 's@"{}.{}".format(binary_base_name, machine)@"${marlin-calc}/bin/marlin-calc"@' -i */analyzers/analyze_progress.py
      '';

      meta = with stdenv.lib; {
        description = "Better print time estimation for OctoPrint";
        homepage = "https://github.com/eyal0/OctoPrint-PrintTimeGenius";
        license = licenses.agpl3;
        maintainers = with maintainers; [ gebner ];
      };
    };

  };

in self
