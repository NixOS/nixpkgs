{ stdenv
, buildGoModule
, fetchgit
, go-bindata
, git
}:

buildGoModule rec {
  pname = "waypoint";
  version = "0.1.2";
  rev = "v${version}";

  # Waypoint is built through a Makefile, which reads information from the Git
  # repository. We use fetchgit instead of fetchFromGitHub, to preserve the .git
  # directory and keep the upstream Makefile intact.
  src = fetchgit {
    url = "https://github.com/hashicorp/waypoint.git";
    sha256 = "19ycqmqppqxbg2j5y2p8kq0f1pwihxjqbhibpf8r9dpwx36i5jbf";
    leaveDotGit = true;
    inherit rev;
  };

  subPackages = ["."];

  vendorSha256 = "0cfr5dvhw9d8yvamc7fi58j11nky0yifrfhzyvaj9p64jll8pv72";
  deleteVendor = true;

  nativeBuildInputs = [ go-bindata git ];
  buildFlagsArray = [
    "-ldflags"
    "-X github.com/hashicorp/waypoint/version.GitDescribe=v${version}"
  ];

  CGO_ENABLED = 0;
  dontPatchELF = true;

  buildPhase = ''
    make bin
    mkdir -p $out/bin
    cp waypoint{,-entrypoint} $out/bin/
  '';

  testPhase = ''
    make test
  '';

  meta = with stdenv.lib; {
    description = "A tool to build, deploy, and release any application on any platform.";
    homepage = "https://www.waypointproject.io/";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ winpat ];
  };
}
