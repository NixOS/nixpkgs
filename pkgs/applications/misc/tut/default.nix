{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "0c44mgkmjnfpf06cj63i6mscxcsm5cipm0l4n6pjxhc7k3qhgsfw";
  };

  modSha256 = "02xwf4l7860mfdbk8jikpf2g4p5ck760qnv1ka4qhxzizqqgcizv";

  meta = with stdenv.lib; {
    description = "TUI for Mastodon";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
