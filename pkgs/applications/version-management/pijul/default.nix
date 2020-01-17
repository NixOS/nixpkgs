{ stdenv, fetchurl, rustPlatform, darwin, openssl, libsodium, nettle, clang, libclang, pkgconfig }:

let
  # nettle-sys=1.0.1 requires the des-compat.h header, but it was removed in
  # nettle 3.5.  See https://nest.pijul.com/pijul_org/pijul/discussions/416
  # Remove with the next release
  nettle_34 = nettle.overrideAttrs (_oldAttrs: rec {
    version = "3.4.1";
    src = fetchurl {
      url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
      sha256 = "1bcji95n1iz9p9vsgdgr26v6s7zhpsxfbjjwpqcihpfd6lawyhgr";
    };
  });
in rustPlatform.buildRustPackage rec {
  pname = "pijul";
  version = "0.12.0";

  src = fetchurl {
    url = "https://pijul.org/releases/${pname}-${version}.tar.gz";
    sha256 = "1rm787kkh3ya8ix0rjvj7sbrg9armm0rnpkga6gjmsbg5bx20y4q";
  };

  nativeBuildInputs = [ pkgconfig clang ];

  postInstall = ''
    mkdir -p $out/share/{bash-completion/completions,zsh/site-functions,fish/vendor_completions.d}
    $out/bin/pijul generate-completions --bash > $out/share/bash-completion/completions/pijul
    $out/bin/pijul generate-completions --zsh > $out/share/zsh/site-functions/_pijul
    $out/bin/pijul generate-completions --fish > $out/share/fish/vendor_completions.d/pijul.fish
  '';

  LIBCLANG_PATH = libclang + "/lib";

  buildInputs = [ openssl libsodium nettle_34 libclang ] ++ stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ CoreServices Security ]);

  doCheck = false;

  cargoSha256 = "1w77s5q18yr1gqqif15wmrfdvv2chq8rq3w4dnmxg2gn0r7bmz2k";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
