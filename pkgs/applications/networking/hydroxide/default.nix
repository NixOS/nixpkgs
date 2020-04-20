{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "hydroxide";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rn35iyli80kgj3yn93lrx0ybgc8fhvmkvx1d18ill7r4cmavand";
  };

  modSha256 = "0b19rcif8yiyvhrsjd3q5nsvr580lklamlphx4dk47n456ckcqfp";

  # FIXME: remove with next release
  patches = [
    (fetchpatch {
      url = "https://github.com/emersion/hydroxide/commit/80e0fa6f3e0154338fb0af8a82ca32ae6281dd15.patch";
      sha256 = "1xi0clzgz14a7sxnwr0li7sz9p05sfh3zh5iqg2qz5f415k9jknj";
    })
  ];

  subPackages = [ "cmd/hydroxide" ];

  meta = with lib; {
    description = "A third-party, open-source ProtonMail bridge";
    homepage = "https://github.com/emersion/hydroxide";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.unix;
  };
}
