{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, gtk3
, rust
}:

rustPlatform.buildRustPackage rec {
  pname = "effitask";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "sanpii";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "09bffxdp43s8b1rpmsgqr2kyz3i4jbd2yrwbxw21fj3sf3mwb9ig";
  };

  # workaround for missing Cargo.lock file https://github.com/sanpii/effitask/issues/48
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "0dvmp23kny6rlv6c0mfyy3cmz1bi5wcm1mxps4z67lym5kxfd362";

  buildInputs = [ openssl gtk3 ];

  nativeBuildInputs = [ pkg-config ];

  # default installPhase don't install assets
  installPhase = ''
    runHook preInstall
    make install PREFIX="$out" TARGET="target/${rust.toRustTarget stdenv.hostPlatform}/release/effitask"
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Graphical task manager, based on the todo.txt format";
    longDescription = ''
      To use it as todo.sh add-on, create a symlink like this:
      mkdir ~/.todo.actions.d/
      ln -s $(which effitask) ~/.todo.actions.d/et

      Or use it as standalone program by defining some environment variables
      like described in the projects readme.
    '';
    homepage = "https://github.com/sanpii/effitask";
    maintainers = with maintainers; [ davidak ];
    license = with licenses; [ mit ];
  };
}
