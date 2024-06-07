{ lib
, config
, fetchFromGitHub
, fetchFromGitLab
, fetchpatch
, marlin-calc
}:

self: super:
let
  buildPlugin = args: self.buildPythonPackage (args // {
    pname = "octoprint-plugin-${args.pname}";
    inherit (args) version;
    propagatedBuildInputs = (args.propagatedBuildInputs or [ ]) ++ [ super.octoprint ];
    # none of the following have tests
    doCheck = false;
  });
in
{
  inherit buildPlugin;

  m86motorsoff = buildPlugin rec {
    pname = "m84motorsoff";
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "ntoff";
      repo = "Octoprint-M84MotOff";
      rev = "v${version}";
      sha256 = "1w6h4hia286lbz2gy33rslq02iypx067yqn413xcipb07ivhvdq7";
    };

    meta = with lib; {
      description = "Changes the \"Motors off\" button in octoprint's control tab to issue an M84 command to allow compatibility with Repetier firmware Resources";
      homepage = "https://github.com/ntoff/OctoPrint-M84MotOff";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ stunkymonkey ];
    };
  };

  abl-expert = buildPlugin rec {
    pname = "abl-expert";
    version = "0.6";

    src = fetchFromGitLab {
      domain = "framagit.org";
      owner = "razer";
      repo = "Octoprint_ABL_Expert";
      rev = version;
      sha256 = "0ij3rvdwya1sbymwm5swlh2j4jagb6fal945g88zrzh5xf26hzjh";
    };

    meta = with lib; {
      description = "Marlin auto bed leveling control, mesh correction, and z probe handling";
      homepage = "https://framagit.org/razer/Octoprint_ABL_Expert/";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ WhittlesJr ];
    };
  };

  bedlevelvisualizer = buildPlugin rec {
    pname = "bedlevelvisualizer";
    version = "1.1.1";

    src = fetchFromGitHub {
      owner = "jneilliii";
      repo = "OctoPrint-BedLevelVisualizer";
      rev = version;
      sha256 = "sha256-6JcYvYgEmphp5zz4xZi4G0yTo4FCIR6Yh+MXYK7H7+w=";
    };

    meta = with lib; {
      description = "Displays 3D mesh of bed topography report";
      homepage = "https://github.com/jneilliii/OctoPrint-BedLevelVisualizer";
      license = licenses.mit;
      maintainers = with maintainers; [ lovesegfault ];
    };
  };

  costestimation = buildPlugin rec {
    pname = "costestimation";
    version = "3.4.0";

    src = fetchFromGitHub {
      owner = "OllisGit";
      repo = "OctoPrint-CostEstimation";
      rev = version;
      sha256 = "sha256-04OPa/RpM8WehUmOp195ocsAjAvKdVY7iD5ybzQO7Dg=";
    };

    meta = with lib; {
      description = "Plugin to display the estimated print cost for the loaded model";
      homepage = "https://github.com/OllisGit/OctoPrint-CostEstimation";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ stunkymonkey ];
    };
  };

  curaenginelegacy = buildPlugin rec {
    pname = "curaenginelegacy";
    version = "1.1.2";

    src = fetchFromGitHub {
      owner = "OctoPrint";
      repo = "OctoPrint-CuraEngineLegacy";
      rev = version;
      sha256 = "sha256-54siSmzgPlnCRpkpZhXU9theNQ3hqL3j+Ip4Ie2w2vA=";
    };

    meta = with lib; {
      description = "Plugin for slicing via Cura Legacy from within OctoPrint";
      homepage = "https://github.com/OctoPrint/OctoPrint-CuraEngineLegacy";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ gebner ];
    };
  };

  displayprogress = buildPlugin rec {
    pname = "displayprogress";
    version = "0.1.3";

    src = fetchFromGitHub {
      owner = "OctoPrint";
      repo = "OctoPrint-DisplayProgress";
      rev = version;
      sha256 = "080prvfwggl4vkzyi369vxh1n8231hrl8a44f399laqah3dn5qw4";
    };

    meta = with lib; {
      description = "Displays the job progress on the printer's display";
      homepage = "https://github.com/OctoPrint/OctoPrint-DisplayProgress";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ stunkymonkey ];
    };
  };

  displaylayerprogress = buildPlugin rec {
    pname = "displaylayerprogress";
    version = "1.26.0";

    src = fetchFromGitHub {
      owner = "OllisGit";
      repo = "OctoPrint-DisplayLayerProgress";
      rev = version;
      sha256 = "sha256-hhHc2SPixZCPJzCP8enMMWNYaYbNZAU0lNSx1B0d++4=";
    };

    meta = with lib; {
      description = "OctoPrint-Plugin that sends the current progress of a print via M117 command";
      homepage = "https://github.com/OllisGit/OctoPrint-DisplayLayerProgress";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ j0hax ];
    };
  };

  ender3v2tempfix = buildPlugin {
    pname = "ender3v2tempfix";
    version = "unstable-2021-04-27";

    src = fetchFromGitHub {
      owner = "SimplyPrint";
      repo = "OctoPrint-Creality2xTemperatureReportingFix";
      rev = "2c4183b6a0242a24ebf646d7ac717cd7a2db2bcf";
      sha256 = "03bc2zbffw4ksk8if90kxhs3179nbhb4xikp4f0adm3lrnvxkd3s";
    };

    meta = with lib; {
      description = "Fixes the double temperature reporting from the Creality Ender-3 v2 printer";
      homepage = "https://github.com/SimplyPrint/OctoPrint-Creality2xTemperatureReportingFix";
      license = licenses.mit;
      maintainers = with maintainers; [ illustris ];
    };
  };

  gcodeeditor = buildPlugin rec {
    pname = "gcodeeditor";
    version = "0.2.12";

    src = fetchFromGitHub {
      owner = "ieatacid";
      repo = "OctoPrint-GcodeEditor";
      rev = version;
      sha256 = "sha256-1Sk2ri3DKW8q8VJ/scFjpRsz65Pwt8OEURP1k70aydE=";
    };

    meta = with lib; {
      description = "Edit gcode on OctoPrint";
      homepage = "https://github.com/ieatacid/OctoPrint-GcodeEditor";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ WhittlesJr ];
    };
  };

  marlingcodedocumentation = buildPlugin rec {
    pname = "marlingcodedocumentation";
    version = "0.13.0";

    src = fetchFromGitHub {
      owner = "costas-basdekis";
      repo = "MarlinGcodeDocumentation";
      rev = "v${version}";
      sha256 = "sha256-3ay6iCxZk8QkFM/2Y14VTpPoxr6NXq14BFSHofn3q7I=";
    };

    meta = with lib; {
      description = "Displays GCode documentation for Marlin in the Octoprint terminal command line";
      homepage = "https://github.com/costas-basdekis/MarlinGcodeDocumentation";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ lovesegfault ];
    };
  };

  mqtt = buildPlugin rec {
    pname = "mqtt";
    version = "0.8.10";

    src = fetchFromGitHub {
      owner = "OctoPrint";
      repo = "OctoPrint-MQTT";
      rev = version;
      sha256 = "sha256-nvEUvN/SdUE1tQkLbxMkZ8xxeUIZiNNirIfWLeH1Kfg=";
    };

    propagatedBuildInputs = with super; [ paho-mqtt ];

    meta = with lib; {
      description = "Publish printer status MQTT";
      homepage = "https://github.com/OctoPrint/OctoPrint-MQTT";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ peterhoeg ];
    };
  };

  printtimegenius = buildPlugin rec {
    pname = "printtimegenius";
    version = "2.3.1";

    src = fetchFromGitHub {
      owner = "eyal0";
      repo = "OctoPrint-PrintTimeGenius";
      rev = version;
      sha256 = "sha256-2lxaTcmPBSdfMmViIfLEbeYWfXZpNVAO4i5Z678gWy0=";
    };

    propagatedBuildInputs = with super; [
      psutil
      sarge
    ];

    preConfigure = ''
      # PrintTimeGenius ships with marlin-calc binaries for multiple architectures
      rm */analyzers/marlin-calc*
      sed 's@"{}.{}".format(binary_base_name, machine)@"${marlin-calc}/bin/marlin-calc"@' -i */analyzers/analyze_progress.py
    '';

    meta = with lib; {
      description = "Better print time estimation for OctoPrint";
      homepage = "https://github.com/eyal0/OctoPrint-PrintTimeGenius";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ gebner ];
    };
  };

  psucontrol = buildPlugin rec {
    pname = "psucontrol";
    version = "1.0.6";

    src = fetchFromGitHub {
      owner = "kantlivelong";
      repo = "OctoPrint-PSUControl";
      rev = version;
      sha256 = "sha256-S+lPm85+ZEO/3BXYsrxE4FU29EGWzWrSw3y1DLdByrM=";
    };

    propagatedBuildInputs = with super; [
      python-periphery
    ];

    preConfigure = ''
      # optional; RPi.GPIO is broken on vanilla kernels
      sed /RPi.GPIO/d -i requirements.txt
    '';

    meta = with lib; {
      description = "OctoPrint plugin to control ATX/AUX power supply";
      homepage = "https://github.com/kantlivelong/OctoPrint-PSUControl";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ gebner ];
    };
  };

  simpleemergencystop = buildPlugin rec {
    pname = "simpleemergencystop";
    version = "1.0.5";

    src = fetchFromGitHub {
      owner = "Sebclem";
      repo = "OctoPrint-SimpleEmergencyStop";
      rev = version;
      sha256 = "sha256-MbP3cKa9FPElQ/M8ykYh9kVXl8hNvmGiCHDvjgWvm9k=";
    };

    meta = with lib; {
      description = "A simple plugin that add an emergency stop buton on NavBar of OctoPrint";
      homepage = "https://github.com/Sebclem/OctoPrint-SimpleEmergencyStop";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ WhittlesJr ];
    };
  };

  stlviewer = buildPlugin rec {
    pname = "stlviewer";
    version = "0.4.2";

    src = fetchFromGitHub {
      owner = "jneilliii";
      repo = "OctoPrint-STLViewer";
      rev = "refs/tags/${version}";
      sha256 = "sha256-S7zjEbyo59OJpa7INCv1o4ybQ+Sy6a3EJ5AJ6wiBe1Y=";
    };

    meta = with lib; {
      description = "A simple stl viewer tab for OctoPrint";
      homepage = "https://github.com/jneilliii/Octoprint-STLViewer";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  telegram = buildPlugin rec {
    pname = "telegram";
    version = "1.6.5";

    src = fetchFromGitHub {
      owner = "fabianonline";
      repo = "OctoPrint-Telegram";
      rev = version;
      sha256 = "sha256-SckJCbPNCflgGYLHFiXy0juCtpvo8YS1BQsFpc1f5rg=";
    };

    propagatedBuildInputs = with super; [ pillow ];

    meta = with lib; {
      description = "Plugin to send status messages and receive commands via Telegram messenger";
      homepage = "https://github.com/fabianonline/OctoPrint-Telegram";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ stunkymonkey ];
    };
  };

  themeify = buildPlugin rec {
    pname = "themeify";
    version = "1.2.2";

    src = fetchFromGitHub {
      owner = "Birkbjo";
      repo = "Octoprint-Themeify";
      rev = "v${version}";
      sha256 = "sha256-om9IUSmxU8y0x8DrodW1EU/pilAN3+PbtYck6KfROEg=";
    };

    meta = with lib; {
      description = "Beautiful themes for OctoPrint";
      homepage = "https://github.com/birkbjo/OctoPrint-Themeify";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ lovesegfault ];
    };
  };

  titlestatus = buildPlugin rec {
    pname = "titlestatus";
    version = "0.0.5";

    src = fetchFromGitHub {
      owner = "MoonshineSG";
      repo = "OctoPrint-TitleStatus";
      rev = version;
      sha256 = "10nxjrixg0i6n6x8ghc1ndshm25c97bvkcis5j9kmlkkzs36i2c6";
    };

    meta = with lib; {
      description = "Show printers status in window title";
      homepage = "https://github.com/MoonshineSG/OctoPrint-TitleStatus";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ abbradar ];
    };
  };

  touchui = buildPlugin rec {
    pname = "touchui";
    version = "0.3.18";

    src = fetchFromGitHub {
      owner = "BillyBlaze";
      repo = "OctoPrint-TouchUI";
      rev = version;
      sha256 = "sha256-PNDCjY7FhfnwK7Nd86el9ZQ00G4uMANH2Sk080iMYXw=";
    };

    meta = with lib; {
      description = "Touch friendly interface for a small TFT module or phone for OctoPrint";
      homepage = "https://github.com/BillyBlaze/OctoPrint-TouchUI";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ gebner ];
    };
  };

  octoklipper = buildPlugin rec {
    pname = "octoklipper";
    version = "0.3.8.3";

    src = fetchFromGitHub {
      owner = "AliceGrey";
      repo = "OctoprintKlipperPlugin";
      rev = version;
      sha256 = "sha256-6r5jJDSR0DxlDQ/XWmQgYUgeL1otNNBnwurX7bbcThg=";
    };

    meta = with lib; {
      description = "A plugin for a better integration of Klipper into OctoPrint";
      homepage = "https://github.com/AliceGrey/OctoprintKlipperPlugin";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ lovesegfault ];
    };
  };

  octolapse = buildPlugin rec {
    pname = "octolapse";
    version = "0.4.2";

    src = fetchFromGitHub {
      owner = "FormerLurker";
      repo = "Octolapse";
      rev = "v${version}";
      sha256 = "sha256-QP6PkKWKUv4uIaYdqTAsZmK7DVes94Q9K/DrBYrWxzY=";
    };

    patches = [
      # fix version constraint
      # https://github.com/FormerLurker/Octolapse/pull/894
      (fetchpatch {
        url = "https://github.com/FormerLurker/Octolapse/commit/0bd7db2430aef370f2665c6c7011fc3bb559122e.patch";
        hash = "sha256-z2aEq5sJGarGtIDbTRCvXdSj+kq8HIVvLRWpKutmJNY=";
      })
    ];

    # Test fails due to code executed on import, see #136513
    #pythonImportsCheck = [ "octoprint_octolapse" ];

    propagatedBuildInputs = with super; [ awesome-slugify setuptools pillow sarge six pillow psutil file-read-backwards ];

    meta = with lib; {
      description = "Stabilized timelapses for Octoprint";
      homepage = "https://github.com/FormerLurker/OctoLapse";
      license = licenses.agpl3Plus;
      maintainers = with maintainers; [ illustris j0hax ];
      # requires pillow >=6.2.0,<7.0.0
      broken = true;
    };
  };

  dashboard = buildPlugin rec {
    pname = "dashboard";
    version = "1.18.3";

    src = fetchFromGitHub {
      owner = "StefanCohen";
      repo = "OctoPrint-Dashboard";
      rev = version;
      sha256 = "sha256-hLHT3Uze/6PlOCEICVZ2ieFTyXgcqCvgHOlIIEquujg=";
    };

    meta = with lib; {
      description = "A dashboard for Octoprint";
      homepage = "https://github.com/StefanCohen/OctoPrint-Dashboard";
      license = licenses.agpl3Plus;
      maintainers = with maintainers; [ j0hax ];
    };
  };
} // lib.optionalAttrs config.allowAliases {
  octoprint-dashboard = super.dashboard;
}
