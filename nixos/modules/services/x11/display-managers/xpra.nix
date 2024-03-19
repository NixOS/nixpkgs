{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.displayManager.xpra;
  dmcfg = config.services.xserver.displayManager;

in

{
  ###### interface

  options = {
    services.xserver.displayManager.xpra = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to enable xpra as display manager.";
      };

      bindTcp = mkOption {
        default = "127.0.0.1:10000";
        example = "0.0.0.0:10000";
        type = types.nullOr types.str;
        description = lib.mdDoc "Bind xpra to TCP";
      };

      desktop = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "gnome-shell";
        description = lib.mdDoc "Start a desktop environment instead of seamless mode";
      };

      auth = mkOption {
        type = types.str;
        default = "pam";
        example = "password:value=mysecret";
        description = lib.mdDoc "Authentication to use when connecting to xpra";
      };

      pulseaudio = mkEnableOption (lib.mdDoc "pulseaudio audio streaming");

      extraOptions = mkOption {
        description = lib.mdDoc "Extra xpra options";
        default = [];
        type = types.listOf types.str;
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["dummy"];

    services.xserver.monitorSection = ''
      HorizSync   1.0 - 2000.0
      VertRefresh 1.0 - 200.0
      #To add your own modes here, use a modeline calculator, like:
      # cvt:
      # https://www.x.org/archive/X11R7.5/doc/man/man1/cvt.1.html
      # xtiming:
      # https://xtiming.sourceforge.net/cgi-bin/xtiming.pl
      # gtf:
      # https://gtf.sourceforge.net/
      #This can be used to get a specific DPI, but only for the default resolution:
      #DisplaySize 508 317
      #NOTE: the highest modes will not work without increasing the VideoRam
      # for the dummy video card.
      #Modeline "16000x15000" 300.00  16000 16408 18000 20000  15000 15003 15013 15016
      #Modeline "15000x15000" 281.25  15000 15376 16872 18744  15000 15003 15013 15016
      #Modeline "16384x8192" 167.75  16384 16800 18432 20480  8192 8195 8205 8208
      #Modeline "15360x8640" 249.00 15360 15752 17280 19200 8640 8643 8648 8651
      Modeline "8192x4096" 193.35 8192 8224 8952 8984 4096 4196 4200 4301
      Modeline "7680x4320" 208.00 7680 7880 8640 9600 4320 4323 4328 4335
      Modeline "6400x4096" 151.38 6400 6432 7000 7032 4096 4196 4200 4301
      Modeline "6400x2560" 91.59 6400 6432 6776 6808 2560 2623 2626 2689
      Modeline "6400x2160" 160.51 6400 6432 7040 7072 2160 2212 2216 2269
      Modeline "5760x2160" 149.50 5760 5768 6320 6880 2160 2161 2164 2173
      Modeline "5680x1440" 142.66 5680 5712 6248 6280 1440 1474 1478 1513
      Modeline "5496x1200" 199.13 5496 5528 6280 6312 1200 1228 1233 1261
      Modeline "5280x2560" 75.72 5280 5312 5592 5624 2560 2623 2626 2689
      Modeline "5280x1920" 56.04 5280 5312 5520 5552 1920 1967 1969 2017
      Modeline "5280x1200" 191.40 5280 5312 6032 6064 1200 1228 1233 1261
      Modeline "5280x1080" 169.96 5280 5312 5952 5984 1080 1105 1110 1135
      Modeline "5120x3200" 199.75 5120 5152 5904 5936 3200 3277 3283 3361
      Modeline "5120x2560" 73.45 5120 5152 5424 5456 2560 2623 2626 2689
      Modeline "5120x2880" 185.50 5120 5256 5760 6400 2880 2883 2888 2899
      Modeline "4800x1200" 64.42 4800 4832 5072 5104 1200 1229 1231 1261
      Modeline "4720x3840" 227.86 4720 4752 5616 5648 3840 3933 3940 4033
      Modeline "4400x2560" 133.70 4400 4432 4936 4968 2560 2622 2627 2689
      Modeline "4480x1440" 72.94 4480 4512 4784 4816 1440 1475 1478 1513
      Modeline "4240x1440" 69.09 4240 4272 4528 4560 1440 1475 1478 1513
      Modeline "4160x1440" 67.81 4160 4192 4448 4480 1440 1475 1478 1513
      Modeline "4096x2304" 249.25 4096 4296 4720 5344 2304 2307 2312 2333
      Modeline "4096x2160" 111.25 4096 4200 4608 5120 2160 2163 2173 2176
      Modeline "4000x1660" 170.32 4000 4128 4536 5072 1660 1661 1664 1679
      Modeline "4000x1440" 145.00 4000 4088 4488 4976 1440 1441 1444 1457
      Modeline "3904x1440" 63.70 3904 3936 4176 4208 1440 1475 1478 1513
      Modeline "3840x2880" 133.43 3840 3872 4376 4408 2880 2950 2955 3025
      Modeline "3840x2560" 116.93 3840 3872 4312 4344 2560 2622 2627 2689
      Modeline "3840x2160" 104.25 3840 3944 4320 4800 2160 2163 2168 2175
      Modeline "3840x2048" 91.45 3840 3872 4216 4248 2048 2097 2101 2151
      Modeline "3840x1200" 108.89 3840 3872 4280 4312 1200 1228 1232 1261
      Modeline "3840x1080" 100.38 3840 3848 4216 4592 1080 1081 1084 1093
      Modeline "3864x1050" 94.58 3864 3896 4248 4280 1050 1074 1078 1103
      Modeline "3600x1200" 106.06 3600 3632 3984 4368 1200 1201 1204 1214
      Modeline "3600x1080" 91.02 3600 3632 3976 4008 1080 1105 1109 1135
      Modeline "3520x1196" 99.53 3520 3552 3928 3960 1196 1224 1228 1256
      Modeline "3360x2560" 102.55 3360 3392 3776 3808 2560 2622 2627 2689
      Modeline "3360x1050" 293.75 3360 3576 3928 4496 1050 1053 1063 1089
      Modeline "3288x1080" 39.76 3288 3320 3464 3496 1080 1106 1108 1135
      Modeline "3200x1800" 233.00 3200 3384 3720 4240  1800 1803 1808 1834
      Modeline "3200x1080" 236.16 3200 3232 4128 4160 1080 1103 1112 1135
      Modeline "3120x2560" 95.36 3120 3152 3512 3544 2560 2622 2627 2689
      Modeline "3120x1050" 272.75 3120 3320 3648 4176 1050 1053 1063 1089
      Modeline "3072x2560" 93.92 3072 3104 3456 3488 2560 2622 2627 2689
      Modeline "3008x1692" 130.93 3008 3112 3416 3824 1692 1693 1696 1712
      Modeline "3000x2560" 91.77 3000 3032 3376 3408 2560 2622 2627 2689
      Modeline "2880x1620" 396.25 2880 3096 3408 3936 1620 1623 1628 1679
      Modeline "2728x1680" 148.02 2728 2760 3320 3352 1680 1719 1726 1765
      Modeline "2560x2240" 151.55 2560 2688 2952 3344 2240 2241 2244 2266
      Modeline "2560x1600" 47.12 2560 2592 2768 2800 1600 1639 1642 1681
      Modeline "2560x1440" 42.12 2560 2592 2752 2784 1440 1475 1478 1513
      Modeline "2560x1400" 267.86 2560 2592 3608 3640 1400 1429 1441 1471
      Modeline "2048x2048" 49.47 2048 2080 2264 2296 2048 2097 2101 2151
      Modeline "2048x1536" 80.06 2048 2104 2312 2576 1536 1537 1540 1554
      Modeline "2048x1152" 197.97 2048 2184 2408 2768 1152 1153 1156 1192
      Modeline "2048x1152" 165.92 2048 2080 2704 2736 1152 1176 1186 1210
      Modeline "1920x1440" 69.47 1920 1960 2152 2384 1440 1441 1444 1457
      Modeline "1920x1200" 26.28 1920 1952 2048 2080 1200 1229 1231 1261
      Modeline "1920x1080" 23.53 1920 1952 2040 2072 1080 1106 1108 1135
      Modeline "1728x1520" 205.42 1728 1760 2536 2568 1520 1552 1564 1597
      Modeline "1680x1050" 20.08 1680 1712 1784 1816 1050 1075 1077 1103
      Modeline "1600x1200" 22.04 1600 1632 1712 1744 1200 1229 1231 1261
      Modeline "1600x900" 33.92 1600 1632 1760 1792 900 921 924 946
      Modeline "1440x900" 30.66 1440 1472 1584 1616 900 921 924 946
      Modeline "1400x900" 103.50 1400 1480 1624 1848 900 903 913 934
      ModeLine "1366x768" 72.00 1366 1414 1446 1494  768 771 777 803
      Modeline "1360x768" 24.49 1360 1392 1480 1512 768 786 789 807
      Modeline "1280x1024" 31.50 1280 1312 1424 1456 1024 1048 1052 1076
      Modeline "1280x800" 24.15 1280 1312 1400 1432 800 819 822 841
      Modeline "1280x768" 23.11 1280 1312 1392 1424 768 786 789 807
      Modeline "1280x720" 59.42 1280 1312 1536 1568 720 735 741 757
      Modeline "1024x768" 18.71 1024 1056 1120 1152 768 786 789 807
      Modeline "1024x640" 41.98 1024 1056 1208 1240 640 653 659 673
      Modeline "1024x576" 46.50 1024 1064 1160 1296  576 579 584 599
      Modeline "768x1024" 19.50 768 800 872 904 1024 1048 1052 1076
      Modeline "960x540" 40.75 960 992 1088 1216 540 543 548 562
      Modeline "864x486"  32.50 864 888 968 1072 486 489 494 506
      Modeline "720x405" 22.50 720 744 808 896  405 408 413 422
      Modeline "640x360" 14.75 640 664 720 800 360 363 368 374
      #common resolutions for android devices (both orientations):
      Modeline "800x1280" 25.89 800 832 928 960 1280 1310 1315 1345
      Modeline "1280x800" 24.15 1280 1312 1400 1432 800 819 822 841
      Modeline "720x1280" 30.22 720 752 864 896 1280 1309 1315 1345
      Modeline "1280x720" 27.41 1280 1312 1416 1448 720 737 740 757
      Modeline "768x1024" 24.93 768 800 888 920 1024 1047 1052 1076
      Modeline "1024x768" 23.77 1024 1056 1144 1176 768 785 789 807
      Modeline "600x1024" 19.90 600 632 704 736 1024 1047 1052 1076
      Modeline "1024x600" 18.26 1024 1056 1120 1152 600 614 617 631
      Modeline "536x960" 16.74 536 568 624 656 960 982 986 1009
      Modeline "960x536" 15.23 960 992 1048 1080 536 548 551 563
      Modeline "600x800" 15.17 600 632 688 720 800 818 822 841
      Modeline "800x600" 14.50 800 832 880 912 600 614 617 631
      Modeline "480x854" 13.34 480 512 560 592 854 873 877 897
      Modeline "848x480" 12.09 848 880 920 952 480 491 493 505
      Modeline "480x800" 12.43 480 512 552 584 800 818 822 841
      Modeline "800x480" 11.46 800 832 872 904 480 491 493 505
      #resolutions for android devices (both orientations)
      #minus the status bar
      #38px status bar (and width rounded up)
      Modeline "800x1242" 25.03 800 832 920 952 1242 1271 1275 1305
      Modeline "1280x762" 22.93 1280 1312 1392 1424 762 780 783 801
      Modeline "720x1242" 29.20 720 752 856 888 1242 1271 1276 1305
      Modeline "1280x682" 25.85 1280 1312 1408 1440 682 698 701 717
      Modeline "768x986" 23.90 768 800 888 920 986 1009 1013 1036
      Modeline "1024x730" 22.50 1024 1056 1136 1168 730 747 750 767
      Modeline "600x986" 19.07 600 632 704 736 986 1009 1013 1036
      Modeline "1024x562" 17.03 1024 1056 1120 1152 562 575 578 591
      Modeline "536x922" 16.01 536 568 624 656 922 943 947 969
      Modeline "960x498" 14.09 960 992 1040 1072 498 509 511 523
      Modeline "600x762" 14.39 600 632 680 712 762 779 783 801
      Modeline "800x562" 13.52 800 832 880 912 562 575 578 591
      Modeline "480x810" 12.59 480 512 552 584 810 828 832 851
      Modeline "848x442" 11.09 848 880 920 952 442 452 454 465
      Modeline "480x762" 11.79 480 512 552 584 762 779 783 801
    '';

    services.xserver.resolutions = [
      {x="8192"; y="4096";}
      {x="5120"; y="3200";}
      {x="3840"; y="2880";}
      {x="3840"; y="2560";}
      {x="3840"; y="2048";}
      {x="3840"; y="2160";}
      {x="2048"; y="2048";}
      {x="2560"; y="1600";}
      {x="1920"; y="1440";}
      {x="1920"; y="1200";}
      {x="1920"; y="1080";}
      {x="1600"; y="1200";}
      {x="1680"; y="1050";}
      {x="1600"; y="900";}
      {x="1400"; y="1050";}
      {x="1440"; y="900";}
      {x="1280"; y="1024";}
      {x="1366"; y="768";}
      {x="1280"; y="800";}
      {x="1024"; y="768";}
      {x="1024"; y="600";}
      {x="800"; y="600";}
      {x="320"; y="200";}
    ];

    services.xserver.serverFlagsSection = ''
      Option "DontVTSwitch" "true"
      Option "PciForceNone" "true"
      Option "AutoEnableDevices" "false"
      Option "AutoAddDevices" "false"
    '';

    services.xserver.deviceSection = ''
      VideoRam 192000
    '';

    services.xserver.displayManager.job.execCmd = ''
      ${optionalString (cfg.pulseaudio)
        "export PULSE_COOKIE=/run/pulse/.config/pulse/cookie"}
      exec ${pkgs.xpra}/bin/xpra ${if cfg.desktop == null then "start" else "start-desktop --start=${cfg.desktop}"} \
        --daemon=off \
        --log-dir=/var/log \
        --log-file=xpra.log \
        --opengl=on \
        --clipboard=on \
        --notifications=on \
        --speaker=yes \
        --mdns=no \
        --pulseaudio=no \
        ${optionalString (cfg.pulseaudio) "--sound-source=pulse"} \
        --socket-dirs=/run/xpra \
        --xvfb="xpra_Xdummy ${concatStringsSep " " dmcfg.xserverArgs}" \
        ${optionalString (cfg.bindTcp != null) "--bind-tcp=${cfg.bindTcp}"} \
        --auth=${cfg.auth} \
        ${concatStringsSep " " cfg.extraOptions}
    '';

    services.xserver.terminateOnReset = false;

    environment.systemPackages = [pkgs.xpra];

    virtualisation.virtualbox.guest.x11 = false;
    hardware.pulseaudio.enable = mkDefault cfg.pulseaudio;
    hardware.pulseaudio.systemWide = mkDefault cfg.pulseaudio;
  };

}
