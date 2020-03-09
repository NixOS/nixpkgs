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

  cargoSha256 = "0rf8qmgzgyl718yznbskzafyg963ygibjmqncd93zdandgl9nj5v";

  # N.B. The cargo depfile checker expects us to have unpacked the src tarball
  # into the standard dirname "source".
  cargoDepsHook = ''
    ln -s ${pname}-${version} source
  '';

  # TODO: Delete once pijul fixes upstream:
  # https://nest.pijul.com/pijul_org/pijul/discussions/447
  postPatch = ''
    pushd ../${pname}-${version}-vendor.tar.gz/thrussh/
    patch -p1 < ${./thrussh-build-fix.patch}
    substituteInPlace .cargo-checksum.json --replace \
      9696ed2422a483cd8de48ac241178a0441be6636909c76174c536b8b1cba9d45 \
      a199f2bba520d56e11607b77be4dde0cfae576c90badb9fbd39af4784e8120d1
    popd
  '';

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

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
