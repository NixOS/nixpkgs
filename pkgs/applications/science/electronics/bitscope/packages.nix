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
        url = "https://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
        url = "https://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
        url = "https://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
        url = "https://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
        url = "https://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
        url = "https://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
        url = "https://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
        url = "https://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };
    };
}
