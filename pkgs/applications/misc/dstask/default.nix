{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dstask";
  version = "0.23";

  src = fetchFromGitHub {
    owner = "naggie";
    repo = pname;
    rev = "v${version}";
    sha256 = "15hr0ivwvm2lzpi8l5y5a3hya3i7r85pxna961m24gd4f8gs4cjl";
  };

  # Set vendorSha256 to null because dstask vendors its dependencies (meaning
  # that third party dependencies are stored in the repository).
  #
  # Ref <https://github.com/NixOS/nixpkgs/pull/87383#issuecomment-633204382>
  # and <https://github.com/NixOS/nixpkgs/blob/d4226e3a4b5fcf988027147164e86665d382bbfa/pkgs/development/go-modules/generic/default.nix#L18>
  vendorSha256 = null;

  doCheck = false;

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
