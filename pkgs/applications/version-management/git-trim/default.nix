{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, libgit2
, IOKit
, CoreFoundation
, Security
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "git-trim";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "foriequal0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XAO3Qg5I2lYZVNx4+Z5jKHRIFdNwBJsUQwJXFb4CbvM=";
  };

  cargoHash = "sha256-mS8kNkZs8jX99ryG4XkU+U/iWIIcmET2vOfG1YNNZFU=";

  cargoPatches = [
    # Update git2 https://github.com/foriequal0/git-trim/pull/202
    (fetchpatch {
      url = "https://github.com/foriequal0/git-trim/commit/4355cd1d6f605455087c4d7ad16bfb92ffee941f.patch";
      sha256 = "sha256-C1pX4oe9ZCgvqYTBJeSjMdr0KFyjv2PNVMJDlwCAngY=";
    })
  ];

  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl libgit2 ]
    ++ lib.optionals stdenv.isDarwin [ IOKit CoreFoundation Security ];

  postInstall = ''
    install -Dm644 -t $out/share/man/man1/ docs/git-trim.1
  '';

  # fails with sandbox
  doCheck = false;

  meta = with lib; {
    description = "Automatically trims your branches whose tracking remote refs are merged or gone";
    homepage = "https://github.com/foriequal0/git-trim";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
