{
  lib,
  stdenv,
  fetchpatch,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  libcap,
  go,
}:

let

  # Note: this module is actually the source code of crypto/x509
  # taken from the Go stdlib and patcheed. So, it can't simply
  # be pinned and added to the vendor dir as everything else.
  x509 = stdenv.mkDerivation rec {
    pname = "x509-compressed";
    version = "0.0.3";

    src = fetchFromGitHub {
      owner = "namecoin";
      repo = "x509-compressed";
      rev = "v${version}";
      hash = "sha256-BmVtClZ3TsUbQrhwREXa42pUOlkBA4a2HVBzl1sdBIo=";
    };

    patches = [
      # https://github.com/namecoin/x509-compressed/pull/4
      (fetchpatch {
        url = "https://github.com/namecoin/x509-compressed/commit/b4fb598b.patch";
        hash = "sha256-S4Y4B4FH15IyaTJtSb03C8QffnsMXSYc6q1Gka/PVV4=";
      })
    ];

    nativeBuildInputs = [ go ];

    buildPhase = ''
      # Put in our own lockfiles
      cp ${./x509-go.mod} go.mod
      cp ${./x509-go.sum} go.sum

      # Generate Go code
      env HOME=/tmp go generate ./...

      # Clean up more references to internal modules
      # (see https://github.com/namecoin/x509-compressed/pull/4)
      sed -e '/import "internal/d' \
          -e 's/goos.IsAndroid/0/g' -i x509/*.go
    '';

    installPhase = ''
      cp -r . "$out"
    '';
  };

in

buildGoModule {
  pname = "ncdns";
  version = "unstable-2024-05-18";

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "ncdns";
    rev = "8a9f7c3037384f12fae400268d0a7f79d26b5532";
    hash = "sha256-lFpjfpOAgvYoV3ci2oSdy8ZOlQ2rWlApiFWcvOMdkyk=";
  };

  # Note: to update ncdns add the following lines
  #
  #   chmod -R +w .
  #   go mod tidy
  #   cat go.mod go.sum
  #   exit 1
  #
  # to the `preBuild` here and update the lock files
  preBuild = ''
    # Sideload the generated x509 module
    ln -s '${x509}' x509
  '';

  vendorHash = "sha256-FoCK2qkhbc+6D4V77pNLiC9d68nkeYJxb7uiNYEP2Xw=";

  buildInputs = [ libcap ];

  patches = [ ./fix-tpl-path.patch ];

  # Put in our own lockfiles
  postPatch = ''
    cp ${./ncdns-go.mod} go.mod
    cp ${./ncdns-go.sum} go.sum
  '';

  preCheck = ''
    # needed to run the ncdns test suite
    ln -s $PWD/vendor ../go/src
  '';

  postInstall = ''
    mkdir -p "$out/share"
    cp -r _doc "$out/share/doc"
    cp -r _tpl "$out/share/tpl"
  '';

  passthru.tests.ncdns = nixosTests.ncdns;

  meta = with lib; {
    description = "Namecoin to DNS bridge daemon";
    homepage = "https://github.com/namecoin/ncdns";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
