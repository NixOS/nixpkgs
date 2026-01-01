{
  lib,
  config,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchpatch,
  marlin-calc,
}:

self: super:
let
  buildPlugin =
    args:
    self.buildPythonPackage (
      args
      // {
        pname = "octoprint-plugin-${args.pname}";
        inherit (args) version format;
        propagatedBuildInputs = (args.propagatedBuildInputs or [ ]) ++ [ super.octoprint ];
        # none of the following have tests
        doCheck = false;
      }
    );
in
{
  inherit buildPlugin;

  m86motorsoff = buildPlugin rec {
    pname = "m84motorsoff";
    version = "0.1.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "ntoff";
      repo = "Octoprint-M84MotOff";
      rev = "v${version}";
      sha256 = "1w6h4hia286lbz2gy33rslq02iypx067yqn413xcipb07ivhvdq7";
    };

<<<<<<< HEAD
    meta = {
      description = "Changes the \"Motors off\" button in octoprint's control tab to issue an M84 command to allow compatibility with Repetier firmware Resources";
      homepage = "https://github.com/ntoff/OctoPrint-M84MotOff";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ stunkymonkey ];
=======
    meta = with lib; {
      description = "Changes the \"Motors off\" button in octoprint's control tab to issue an M84 command to allow compatibility with Repetier firmware Resources";
      homepage = "https://github.com/ntoff/OctoPrint-M84MotOff";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ stunkymonkey ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  abl-expert = buildPlugin rec {
    pname = "abl-expert";
    version = "0.6";
    format = "setuptools";

    src = fetchFromGitLab {
      domain = "framagit.org";
      owner = "razer";
      repo = "Octoprint_ABL_Expert";
      rev = version;
      sha256 = "0ij3rvdwya1sbymwm5swlh2j4jagb6fal945g88zrzh5xf26hzjh";
    };

<<<<<<< HEAD
    meta = {
      description = "Marlin auto bed leveling control, mesh correction, and z probe handling";
      homepage = "https://framagit.org/razer/Octoprint_ABL_Expert/";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ WhittlesJr ];
=======
    meta = with lib; {
      description = "Marlin auto bed leveling control, mesh correction, and z probe handling";
      homepage = "https://framagit.org/razer/Octoprint_ABL_Expert/";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ WhittlesJr ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  bedlevelvisualizer = buildPlugin rec {
    pname = "bedlevelvisualizer";
    version = "1.1.1";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "jneilliii";
      repo = "OctoPrint-BedLevelVisualizer";
      rev = version;
      sha256 = "sha256-6JcYvYgEmphp5zz4xZi4G0yTo4FCIR6Yh+MXYK7H7+w=";
    };

<<<<<<< HEAD
    meta = {
      description = "Displays 3D mesh of bed topography report";
      homepage = "https://github.com/jneilliii/OctoPrint-BedLevelVisualizer";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ lovesegfault ];
=======
    meta = with lib; {
      description = "Displays 3D mesh of bed topography report";
      homepage = "https://github.com/jneilliii/OctoPrint-BedLevelVisualizer";
      license = licenses.mit;
      maintainers = with maintainers; [ lovesegfault ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  costestimation = buildPlugin rec {
    pname = "costestimation";
    version = "3.4.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "OllisGit";
      repo = "OctoPrint-CostEstimation";
      rev = version;
      sha256 = "sha256-04OPa/RpM8WehUmOp195ocsAjAvKdVY7iD5ybzQO7Dg=";
    };

<<<<<<< HEAD
    meta = {
      description = "Plugin to display the estimated print cost for the loaded model";
      homepage = "https://github.com/OllisGit/OctoPrint-CostEstimation";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ stunkymonkey ];
=======
    meta = with lib; {
      description = "Plugin to display the estimated print cost for the loaded model";
      homepage = "https://github.com/OllisGit/OctoPrint-CostEstimation";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ stunkymonkey ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  curaenginelegacy = buildPlugin rec {
    pname = "curaenginelegacy";
    version = "1.1.2";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "OctoPrint";
      repo = "OctoPrint-CuraEngineLegacy";
      rev = version;
      sha256 = "sha256-54siSmzgPlnCRpkpZhXU9theNQ3hqL3j+Ip4Ie2w2vA=";
    };

<<<<<<< HEAD
    meta = {
      description = "Plugin for slicing via Cura Legacy from within OctoPrint";
      homepage = "https://github.com/OctoPrint/OctoPrint-CuraEngineLegacy";
      license = lib.licenses.agpl3Only;
=======
    meta = with lib; {
      description = "Plugin for slicing via Cura Legacy from within OctoPrint";
      homepage = "https://github.com/OctoPrint/OctoPrint-CuraEngineLegacy";
      license = licenses.agpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      maintainers = [ ];
    };
  };

  displayprogress = buildPlugin rec {
    pname = "displayprogress";
    version = "0.1.3";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "OctoPrint";
      repo = "OctoPrint-DisplayProgress";
      rev = version;
      sha256 = "080prvfwggl4vkzyi369vxh1n8231hrl8a44f399laqah3dn5qw4";
    };

<<<<<<< HEAD
    meta = {
      description = "Displays the job progress on the printer's display";
      homepage = "https://github.com/OctoPrint/OctoPrint-DisplayProgress";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ stunkymonkey ];
=======
    meta = with lib; {
      description = "Displays the job progress on the printer's display";
      homepage = "https://github.com/OctoPrint/OctoPrint-DisplayProgress";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ stunkymonkey ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  displaylayerprogress = buildPlugin rec {
    pname = "displaylayerprogress";
    version = "1.26.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "OllisGit";
      repo = "OctoPrint-DisplayLayerProgress";
      rev = version;
      sha256 = "sha256-hhHc2SPixZCPJzCP8enMMWNYaYbNZAU0lNSx1B0d++4=";
    };

<<<<<<< HEAD
    meta = {
      description = "OctoPrint-Plugin that sends the current progress of a print via M117 command";
      homepage = "https://github.com/OllisGit/OctoPrint-DisplayLayerProgress";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ j0hax ];
=======
    meta = with lib; {
      description = "OctoPrint-Plugin that sends the current progress of a print via M117 command";
      homepage = "https://github.com/OllisGit/OctoPrint-DisplayLayerProgress";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ j0hax ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  ender3v2tempfix = buildPlugin {
    pname = "ender3v2tempfix";
    version = "unstable-2021-04-27";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "SimplyPrint";
      repo = "OctoPrint-Creality2xTemperatureReportingFix";
      rev = "2c4183b6a0242a24ebf646d7ac717cd7a2db2bcf";
      sha256 = "03bc2zbffw4ksk8if90kxhs3179nbhb4xikp4f0adm3lrnvxkd3s";
    };

<<<<<<< HEAD
    meta = {
      description = "Fixes the double temperature reporting from the Creality Ender-3 v2 printer";
      homepage = "https://github.com/SimplyPrint/OctoPrint-Creality2xTemperatureReportingFix";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ illustris ];
=======
    meta = with lib; {
      description = "Fixes the double temperature reporting from the Creality Ender-3 v2 printer";
      homepage = "https://github.com/SimplyPrint/OctoPrint-Creality2xTemperatureReportingFix";
      license = licenses.mit;
      maintainers = with maintainers; [ illustris ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  firmwareupdater = buildPlugin rec {
    pname = "firmwareupdater";
    version = "1.14.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "OctoPrint";
      repo = "OctoPrint-FirmwareUpdater";
      rev = version;
      sha256 = "sha256-CUNjM/IJJS/lqccZ2B0mDOzv3k8AgmDreA/X9wNJ7iY=";
    };

    propagatedBuildInputs = with super; [ pyserial ];

<<<<<<< HEAD
    meta = {
      description = "Printer Firmware Updater";
      homepage = "https://github.com/OctoPrint/OctoPrint-FirmwareUpdater";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ tri-ler ];
=======
    meta = with lib; {
      description = "Printer Firmware Updater";
      homepage = "https://github.com/OctoPrint/OctoPrint-FirmwareUpdater";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ tri-ler ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  fullscreen = buildPlugin rec {
    pname = "fullscreen";
    version = "0.0.6";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "BillyBlaze";
      repo = "OctoPrint-FullScreen";
      rev = version;
      sha256 = "sha256-Z8twpj+gqgbiWWxNd9I9qflEAln5Obpb3cn34KwSc5A=";
    };

<<<<<<< HEAD
    meta = {
      description = "Open webcam in fullscreen mode";
      homepage = "https://github.com/BillyBlaze/OctoPrint-FullScreen";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ tri-ler ];
=======
    meta = with lib; {
      description = "Open webcam in fullscreen mode";
      homepage = "https://github.com/BillyBlaze/OctoPrint-FullScreen";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ tri-ler ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  gcodeeditor = buildPlugin rec {
    pname = "gcodeeditor";
    version = "0.2.12";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "ieatacid";
      repo = "OctoPrint-GcodeEditor";
      rev = version;
      sha256 = "sha256-1Sk2ri3DKW8q8VJ/scFjpRsz65Pwt8OEURP1k70aydE=";
    };

<<<<<<< HEAD
    meta = {
      description = "Edit gcode on OctoPrint";
      homepage = "https://github.com/ieatacid/OctoPrint-GcodeEditor";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ WhittlesJr ];
=======
    meta = with lib; {
      description = "Edit gcode on OctoPrint";
      homepage = "https://github.com/ieatacid/OctoPrint-GcodeEditor";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ WhittlesJr ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  marlingcodedocumentation = buildPlugin rec {
    pname = "marlingcodedocumentation";
    version = "0.13.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "costas-basdekis";
      repo = "MarlinGcodeDocumentation";
      rev = "v${version}";
      sha256 = "sha256-3ay6iCxZk8QkFM/2Y14VTpPoxr6NXq14BFSHofn3q7I=";
    };

<<<<<<< HEAD
    meta = {
      description = "Displays GCode documentation for Marlin in the Octoprint terminal command line";
      homepage = "https://github.com/costas-basdekis/MarlinGcodeDocumentation";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ lovesegfault ];
=======
    meta = with lib; {
      description = "Displays GCode documentation for Marlin in the Octoprint terminal command line";
      homepage = "https://github.com/costas-basdekis/MarlinGcodeDocumentation";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ lovesegfault ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  mqtt = buildPlugin rec {
    pname = "mqtt";
    version = "0.8.16";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "OctoPrint";
      repo = "OctoPrint-MQTT";
      rev = version;
      sha256 = "sha256-K8DydzmsDzWn5GXpxPGvAHDFpgk/mbyVBflCgOoB94U=";
    };

    propagatedBuildInputs = with super; [ paho-mqtt ];

<<<<<<< HEAD
    meta = {
      description = "Publish printer status MQTT";
      homepage = "https://github.com/OctoPrint/OctoPrint-MQTT";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ peterhoeg ];
=======
    meta = with lib; {
      description = "Publish printer status MQTT";
      homepage = "https://github.com/OctoPrint/OctoPrint-MQTT";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ peterhoeg ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  mqttchambertemperature = buildPlugin rec {
    pname = "mqttchambertemperature";
    version = "0.0.3";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "synman";
      repo = "OctoPrint-MqttChamberTemperature";
      rev = version;
      sha256 = "sha256-CvNpi8HcBBUfCs3X8yflbhe0YCU0kW3u2ADSro/qnuI=";
    };

    propagatedBuildInputs = with super; [ jsonpath-ng ];

<<<<<<< HEAD
    meta = {
      description = "Enables Chamber temperature reporting via subscribing to an MQTT topic";
      homepage = "https://github.com/synman/OctoPrint-MqttChamberTemperature";
      license = lib.licenses.wtfpl;
      maintainers = with lib.maintainers; [ tri-ler ];
=======
    meta = with lib; {
      description = "Enables Chamber temperature reporting via subscribing to an MQTT topic";
      homepage = "https://github.com/synman/OctoPrint-MqttChamberTemperature";
      license = licenses.wtfpl;
      maintainers = with maintainers; [ tri-ler ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  navbartemp = buildPlugin rec {
    pname = "navbartemp";
    version = "0.15";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "imrahil";
      repo = "OctoPrint-NavbarTemp";
      rev = version;
      sha256 = "sha256-ZPpTx+AadRffUb53sZbMUbCZa7xYGQW/5si7UB8mnVI=";
    };

<<<<<<< HEAD
    meta = {
      description = "Displays temperatures on navbar";
      homepage = "https://github.com/imrahil/OctoPrint-NavbarTemp";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ tri-ler ];
=======
    meta = with lib; {
      description = "Displays temperatures on navbar";
      homepage = "https://github.com/imrahil/OctoPrint-NavbarTemp";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ tri-ler ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  obico = buildPlugin rec {
    pname = "obico";
    version = "2.5.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "TheSpaghettiDetective";
      repo = "OctoPrint-Obico";
      rev = version;
      sha256 = "sha256-cAUXe/lRTqYuWnrRiNDuDjcayL5yV9/PtTd9oeSC8KA=";
    };

    propagatedBuildInputs = with super; [
      backoff
      sentry-sdk
      bson
      distro
    ];

<<<<<<< HEAD
    meta = {
      description = "Monitor Octoprint-connected printers with Obico";
      homepage = "https://www.obico.io/";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ tri-ler ];
=======
    meta = with lib; {
      description = "Monitor Octoprint-connected printers with Obico";
      homepage = "https://www.obico.io/";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ tri-ler ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  octopod = buildPlugin rec {
    pname = "octopod";
    version = "0.3.18";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "gdombiak";
      repo = "OctoPrint-OctoPod";
      rev = version;
      sha256 = "sha256-HLR5402hFlUX0MLg3HXE7bIHKNnOI0buGAViqDt8mLc=";
    };

    propagatedBuildInputs = with super; [ pillow ];

<<<<<<< HEAD
    meta = {
      description = "OctoPod extension for OctoPrint";
      homepage = "https://github.com/gdombiak/OctoPrint-OctoPod";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ tri-ler ];
=======
    meta = with lib; {
      description = "OctoPod extension for OctoPrint";
      homepage = "https://github.com/gdombiak/OctoPrint-OctoPod";
      license = licenses.asl20;
      maintainers = with maintainers; [ tri-ler ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  printtimegenius = buildPlugin rec {
    pname = "printtimegenius";
    version = "2.4.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "eyal0";
      repo = "OctoPrint-PrintTimeGenius";
      rev = version;
      sha256 = "sha256-+EmM61s8HHcTIf0xoHkxEP7eqaNYB6ls61YwSXiVzyA=";
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

<<<<<<< HEAD
    meta = {
      description = "Better print time estimation for OctoPrint";
      homepage = "https://github.com/eyal0/OctoPrint-PrintTimeGenius";
      license = lib.licenses.agpl3Only;
=======
    meta = with lib; {
      description = "Better print time estimation for OctoPrint";
      homepage = "https://github.com/eyal0/OctoPrint-PrintTimeGenius";
      license = licenses.agpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      maintainers = [ ];
    };
  };

  prusaslicerthumbnails = buildPlugin rec {
    pname = "prusaslicerthumbnails";
    version = "1.0.8";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "jneilliii";
      repo = "OctoPrint-PrusaSlicerThumbnails";
      rev = version;
      sha256 = "sha256-5TUx64i3VIUXtpIf4mo3hP//kXE+LuuLaZEJYgv4hVs=";
    };

    propagatedBuildInputs = with super; [ psutil ];

<<<<<<< HEAD
    meta = {
      description = "Plugin that extracts thumbnails from uploaded gcode files sliced by PrusaSlicer";
      homepage = "https://github.com/jneilliii/OctoPrint-PrusaSlicerThumbnails";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ tri-ler ];
=======
    meta = with lib; {
      description = "Plugin that extracts thumbnails from uploaded gcode files sliced by PrusaSlicer";
      homepage = "https://github.com/jneilliii/OctoPrint-PrusaSlicerThumbnails";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ tri-ler ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  psucontrol = buildPlugin rec {
    pname = "psucontrol";
    version = "1.0.6";
    format = "setuptools";

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

<<<<<<< HEAD
    meta = {
      description = "OctoPrint plugin to control ATX/AUX power supply";
      homepage = "https://github.com/kantlivelong/OctoPrint-PSUControl";
      license = lib.licenses.agpl3Only;
=======
    meta = with lib; {
      description = "OctoPrint plugin to control ATX/AUX power supply";
      homepage = "https://github.com/kantlivelong/OctoPrint-PSUControl";
      license = licenses.agpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      maintainers = [ ];
    };
  };

  resource-monitor = buildPlugin rec {
    pname = "resource-monitor";
    version = "0.3.16";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "Renaud11232";
      repo = "OctoPrint-Resource-Monitor";
      rev = version;
      sha256 = "sha256-w1PBxO+Qf7cSSNocu7BiulZE7kesSa+LGV3uJlmd0ao=";
    };

    propagatedBuildInputs = with super; [ psutil ];

<<<<<<< HEAD
    meta = {
      description = "Plugin to view the current CPU and RAM usage on your system";
      homepage = "https://github.com/Renaud11232/OctoPrint-Resource-Monitor";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ tri-ler ];
=======
    meta = with lib; {
      description = "Plugin to view the current CPU and RAM usage on your system";
      homepage = "https://github.com/Renaud11232/OctoPrint-Resource-Monitor";
      license = licenses.mit;
      maintainers = with maintainers; [ tri-ler ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  simpleemergencystop = buildPlugin rec {
    pname = "simpleemergencystop";
    version = "1.0.5";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "Sebclem";
      repo = "OctoPrint-SimpleEmergencyStop";
      rev = version;
      sha256 = "sha256-MbP3cKa9FPElQ/M8ykYh9kVXl8hNvmGiCHDvjgWvm9k=";
    };

<<<<<<< HEAD
    meta = {
      description = "Simple plugin that add an emergency stop buton on NavBar of OctoPrint";
      homepage = "https://github.com/Sebclem/OctoPrint-SimpleEmergencyStop";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ WhittlesJr ];
=======
    meta = with lib; {
      description = "Simple plugin that add an emergency stop buton on NavBar of OctoPrint";
      homepage = "https://github.com/Sebclem/OctoPrint-SimpleEmergencyStop";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ WhittlesJr ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  stlviewer = buildPlugin rec {
    pname = "stlviewer";
    version = "0.4.2";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "jneilliii";
      repo = "OctoPrint-STLViewer";
      rev = "refs/tags/${version}";
      sha256 = "sha256-S7zjEbyo59OJpa7INCv1o4ybQ+Sy6a3EJ5AJ6wiBe1Y=";
    };

<<<<<<< HEAD
    meta = {
      description = "Simple stl viewer tab for OctoPrint";
      homepage = "https://github.com/jneilliii/Octoprint-STLViewer";
      license = lib.licenses.agpl3Only;
=======
    meta = with lib; {
      description = "Simple stl viewer tab for OctoPrint";
      homepage = "https://github.com/jneilliii/Octoprint-STLViewer";
      license = licenses.agpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      maintainers = [ ];
    };
  };

  telegram = buildPlugin rec {
    pname = "telegram";
    version = "1.6.5";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "fabianonline";
      repo = "OctoPrint-Telegram";
      rev = version;
      sha256 = "sha256-SckJCbPNCflgGYLHFiXy0juCtpvo8YS1BQsFpc1f5rg=";
    };

    propagatedBuildInputs = with super; [ pillow ];

<<<<<<< HEAD
    meta = {
      description = "Plugin to send status messages and receive commands via Telegram messenger";
      homepage = "https://github.com/fabianonline/OctoPrint-Telegram";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ stunkymonkey ];
=======
    meta = with lib; {
      description = "Plugin to send status messages and receive commands via Telegram messenger";
      homepage = "https://github.com/fabianonline/OctoPrint-Telegram";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ stunkymonkey ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  themeify = buildPlugin rec {
    pname = "themeify";
    version = "1.2.2";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "Birkbjo";
      repo = "Octoprint-Themeify";
      rev = "v${version}";
      sha256 = "sha256-om9IUSmxU8y0x8DrodW1EU/pilAN3+PbtYck6KfROEg=";
    };

<<<<<<< HEAD
    meta = {
      description = "Beautiful themes for OctoPrint";
      homepage = "https://github.com/birkbjo/OctoPrint-Themeify";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ lovesegfault ];
=======
    meta = with lib; {
      description = "Beautiful themes for OctoPrint";
      homepage = "https://github.com/birkbjo/OctoPrint-Themeify";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ lovesegfault ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  timelapsepurger = buildPlugin rec {
    pname = "firmwareupdater";
    version = "0.1.4";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "jneilliii";
      repo = "OctoPrint-TimelapsePurger";
      rev = version;
      sha256 = "sha256-XS4m4KByScGTPfVE4kuRLw829gNE2CdM0RyhRqGGxyw=";
    };

<<<<<<< HEAD
    meta = {
      description = "Automatically deletes timelapses that are older than configured timeframe";
      homepage = "https://github.com/jneilliii/OctoPrint-TimelapsePurger";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ tri-ler ];
=======
    meta = with lib; {
      description = "Automatically deletes timelapses that are older than configured timeframe";
      homepage = "https://github.com/jneilliii/OctoPrint-TimelapsePurger";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ tri-ler ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  titlestatus = buildPlugin rec {
    pname = "titlestatus";
    version = "0.0.5";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "MoonshineSG";
      repo = "OctoPrint-TitleStatus";
      rev = version;
      sha256 = "10nxjrixg0i6n6x8ghc1ndshm25c97bvkcis5j9kmlkkzs36i2c6";
    };

<<<<<<< HEAD
    meta = {
      description = "Show printers status in window title";
      homepage = "https://github.com/MoonshineSG/OctoPrint-TitleStatus";
      license = lib.licenses.agpl3Only;
=======
    meta = with lib; {
      description = "Show printers status in window title";
      homepage = "https://github.com/MoonshineSG/OctoPrint-TitleStatus";
      license = licenses.agpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      maintainers = [ ];
    };
  };

  touchui = buildPlugin rec {
    pname = "touchui";
    version = "0.3.18";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "BillyBlaze";
      repo = "OctoPrint-TouchUI";
      rev = version;
      sha256 = "sha256-PNDCjY7FhfnwK7Nd86el9ZQ00G4uMANH2Sk080iMYXw=";
    };

<<<<<<< HEAD
    meta = {
      description = "Touch friendly interface for a small TFT module or phone for OctoPrint";
      homepage = "https://github.com/BillyBlaze/OctoPrint-TouchUI";
      license = lib.licenses.agpl3Only;
=======
    meta = with lib; {
      description = "Touch friendly interface for a small TFT module or phone for OctoPrint";
      homepage = "https://github.com/BillyBlaze/OctoPrint-TouchUI";
      license = licenses.agpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      maintainers = [ ];
    };
  };

  octoklipper = buildPlugin rec {
    pname = "octoklipper";
    version = "0.3.8.3";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "AliceGrey";
      repo = "OctoprintKlipperPlugin";
      rev = version;
      sha256 = "sha256-6r5jJDSR0DxlDQ/XWmQgYUgeL1otNNBnwurX7bbcThg=";
    };

<<<<<<< HEAD
    meta = {
      description = "Plugin for a better integration of Klipper into OctoPrint";
      homepage = "https://github.com/AliceGrey/OctoprintKlipperPlugin";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ lovesegfault ];
=======
    meta = with lib; {
      description = "Plugin for a better integration of Klipper into OctoPrint";
      homepage = "https://github.com/AliceGrey/OctoprintKlipperPlugin";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ lovesegfault ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };

  dashboard = buildPlugin rec {
    pname = "dashboard";
    version = "1.18.3";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "StefanCohen";
      repo = "OctoPrint-Dashboard";
      rev = version;
      sha256 = "sha256-hLHT3Uze/6PlOCEICVZ2ieFTyXgcqCvgHOlIIEquujg=";
    };

<<<<<<< HEAD
    meta = {
      description = "Dashboard for Octoprint";
      homepage = "https://github.com/StefanCohen/OctoPrint-Dashboard";
      license = lib.licenses.agpl3Plus;
      maintainers = with lib.maintainers; [ j0hax ];
=======
    meta = with lib; {
      description = "Dashboard for Octoprint";
      homepage = "https://github.com/StefanCohen/OctoPrint-Dashboard";
      license = licenses.agpl3Plus;
      maintainers = with maintainers; [ j0hax ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };
}
// lib.optionalAttrs config.allowAliases {
  octolapse = throw "octoprint.python.pkgs.octolapse has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-29
  octoprint-dashboard = super.dashboard;
}
