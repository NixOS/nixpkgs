{ stdenv, buildGoPackage, fetchFromGitHub, majorVersion ? "0.11" }:

let
  versionMap = {
    "0.11" = {
      version = "0.11.4";
      sha256 = "1sykp9sji6f564s7bz0cvnr9w5x92n0l1r1djf1bl7jvv2mi1mcb";
    };
    "0.12" = {
      version = "0.12.2";
      sha256 = "1gc286ag6plk5kxw7jzr32cp3n5rwydj1z7rds1rfd0fyq7an404";
    };
  };
in

with versionMap.${majorVersion};

buildGoPackage rec {
  pname = "nomad";
  inherit version;
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/nomad";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    inherit rev sha256;
  };

  # ui:
  #  Nomad release commits include the compiled version of the UI, but the file
  #  is only included if we build with the ui tag.
  # nonvidia:
  #  We disable Nvidia GPU scheduling on Linux, as it doesn't work there:
  #  Ref: https://github.com/hashicorp/nomad/issues/5535
  preBuild = let
    tags = ["ui"]
      ++ stdenv.lib.optional stdenv.isLinux "nonvidia";
    tagsString = stdenv.lib.concatStringsSep " " tags;
  in ''
    export buildFlagsArray=(
      -tags="${tagsString}"
    )
 '';

  meta = with stdenv.lib; {
    homepage = "https://www.nomadproject.io/";
    description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
    platforms = platforms.unix;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem pradeepchhetri endocrimes ];
  };
}
