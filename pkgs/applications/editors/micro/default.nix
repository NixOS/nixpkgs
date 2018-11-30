{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage  rec {
  name = "micro-${version}";
  version = "1.4.1";

  goPackagePath = "github.com/zyedidia/micro";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = "micro";
    rev = "v${version}";
    sha256 = "0m9p6smb5grdazsgr3m1x4rry9ihhlgl9ildhvfp53czrifbx0m5";
    fetchSubmodules = true;
  };

  subPackages = [ "cmd/micro" ];

  buildFlagsArray = [ "-ldflags=" "-X main.Version=${version}" ];

  meta = with stdenv.lib; {
    homepage = https://micro-editor.github.io;
    description = "Modern and intuitive terminal-based text editor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}

