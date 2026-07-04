{
  callPackage,
  fetchurl,
}:

let
  mkBitscope = callPackage (import ./common.nix) { };
in
{
  chart =
    let
      toolName = "bitscope-chart";
      version = "2.0.FK22M";
    in
    mkBitscope {
      inherit toolName version;

      meta = {
        description = "Multi-channel waveform data acquisition and chart recording application";
        homepage = "http://bitscope.com/software/chart/";
      };

      src = fetchurl {
        url = "http://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "08mc82pjamyyyhh15sagsv0sc7yx5v5n54bg60fpj7v41wdwrzxw";
      };
    };

  console =
    let
      toolName = "bitscope-console";
      version = "1.0.FK29A";
    in
    mkBitscope {
      # NOTE: this is meant as a demo by BitScope
      inherit toolName version;

      meta = {
        description = "Demonstrative communications program designed to make it easy to talk to any model BitScope";
      };

      src = fetchurl {
        url = "http://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "00b4gxwz7w6pmfrcz14326b24kl44hp0gzzqcqxwi5vws3f0y49d";
      };
    };

  display =
    let
      toolName = "bitscope-display";
      version = "1.0.EC17A";
    in
    mkBitscope {
      inherit toolName version;

      meta = {
        description = "Display diagnostic application for BitScope";
        homepage = "http://bitscope.com/software/display/";
      };

      src = fetchurl {
        url = "http://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "05xr5mnka1v3ibcasg74kmj6nlv1nmn3lca1wv77whkq85cmz0s1";
      };
    };

  dso =
    let
      toolName = "bitscope-dso";
      version = "2.8.FE22H";
    in
    mkBitscope {
      inherit toolName version;

      meta = {
        description = "Test and measurement software for BitScope";
        homepage = "http://bitscope.com/software/dso/";
      };

      src = fetchurl {
        url = "http://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "0fc6crfkprj78dxxhvhbn1dx1db5chm0cpwlqpqv8sz6whp12mcj";
      };
    };

  logic =
    let
      toolName = "bitscope-logic";
      version = "1.2.FC20C";
    in
    mkBitscope {
      inherit toolName version;

      meta = {
        description = "Mixed signal logic timing and serial protocol analysis software for BitScope";
        homepage = "http://bitscope.com/software/logic/";
      };

      src = fetchurl {
        url = "http://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "0lkb7z9gfkiyxdwh4dq1zxfls8gzdw0na1vrrbgnxfg3klv4xns3";
      };
    };

  meter =
    let
      toolName = "bitscope-meter";
      version = "2.0.FK22G";
    in
    mkBitscope {
      inherit toolName version;

      meta = {
        description = "Automated oscilloscope, voltmeter and frequency meter for BitScope";
        homepage = "http://bitscope.com/software/logic/";
      };

      src = fetchurl {
        url = "http://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "0nirbci6ymhk4h4bck2s4wbsl5r9yndk2jvvv72zwkg21248mnbp";
      };
    };

  proto =
    let
      toolName = "bitscope-proto";
      version = "0.9.FG13B";
    in
    mkBitscope {
      inherit toolName version;
      # NOTE: this is meant as a demo by BitScope
      # NOTE: clicking on logo produces error
      # TApplication.HandleException Executable not found: "http://bitscope.com/blog/DK/?p=DK15A"

      meta = {
        description = "Demonstrative prototype oscilloscope built using the BitScope Library";
        homepage = "http://bitscope.com/blog/DK/?p=DK15A";
      };

      src = fetchurl {
        url = "http://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "1ybjfbh3narn29ll4nci4b7rnxy0hj3wdfm4v8c6pjr8pfvv9spy";
      };
    };

  server =
    let
      toolName = "bitscope-server";
      version = "1.0.FK26A";
    in
    mkBitscope {
      inherit toolName version;

      meta = {
        description = "Remote access server solution for any BitScope";
        homepage = "http://bitscope.com/software/server/";
      };

      src = fetchurl {
        url = "http://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "1079n7msq6ks0n4aasx40rd4q99w8j9hcsaci71nd2im2jvjpw9a";
      };
    };
}
