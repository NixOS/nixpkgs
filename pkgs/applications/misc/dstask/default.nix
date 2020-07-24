{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dstask";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "naggie";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hrhvfkqflr4wx1r2xbfbi566pglrp4rp5yq0cr2ml0x6kw3yz0j";
  };

  # Set vendorSha256 to null because dstask vendors its dependencies (meaning
  # that third party dependencies are stored in the repository).
  #
  # Ref <https://github.com/NixOS/nixpkgs/pull/87383#issuecomment-633204382>
  # and <https://github.com/NixOS/nixpkgs/blob/d4226e3a4b5fcf988027147164e86665d382bbfa/pkgs/development/go-modules/generic/default.nix#L18>
  vendorSha256 = null;

  # The ldflags reduce the executable size by stripping some debug stuff.
  # The other variables are set so that the output of dstask version shows the
  # git ref and the release version from github.
  # Ref <https://github.com/NixOS/nixpkgs/pull/87383#discussion_r432097657>
  buildFlagsArray = [ ''
    -ldflags=-w -s
    -X "github.com/naggie/dstask.VERSION=${version}"
    -X "github.com/naggie/dstask.GIT_COMMIT=v${version}"
  '' ];

  subPackages = [ "cmd/dstask.go" ];

  meta = with stdenv.lib; {
    description = "Command line todo list with super-reliable git sync";
    homepage = src.meta.homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ stianlagstad foxit64 ];
    platforms = platforms.linux;
  };
}
