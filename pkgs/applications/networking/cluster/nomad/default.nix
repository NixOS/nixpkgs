{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "nomad";
  version = "0.9.5";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/nomad";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    inherit rev;
    sha256 = "01491470idb11z0ab4anb5caw46vy9s94a17l92j0z2f3f4k6xfl";
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
    homepage = https://www.nomadproject.io/;
    description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
    platforms = platforms.unix;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem pradeepchhetri ];
  };
}
