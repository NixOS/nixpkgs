{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 =  "1hgw3sxh7ary75286051v5xmdcw70ns1fm7m5nkqz04cx113hlwj";
  };

  vendorSha256 = "0lhml6m0j9ksn09j7z4d9pix5aszhndpyqajycwj3apvi3ic90il";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
