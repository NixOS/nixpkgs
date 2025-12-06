{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "chit";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "peterheesterman";
    repo = "chit";
    rev = version;
    sha256 = "0iixczy3cad44j2d7zzj8f3lnmp4jwnb0snmwfgiq3vj9wrn28pz";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
  ];

  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "Crate help in terminal: A tool for looking up details about rust crates without going to crates.io";
    mainProgram = "chit";
    knownVulnerabilities = [
      "Has not been touched by upstream in 5 years."
      "Dependencies have security issues, including:"
      "https://rustsec.org/advisories/RUSTSEC-2024-0003"
      "https://rustsec.org/advisories/RUSTSEC-2024-0332"
      "https://rustsec.org/advisories/RUSTSEC-2023-0034"
      "https://rustsec.org/advisories/RUSTSEC-2021-0020"
      "https://rustsec.org/advisories/RUSTSEC-2021-0078"
      "https://rustsec.org/advisories/RUSTSEC-2021-0079"
      "https://rustsec.org/advisories/RUSTSEC-2024-0421"
      "https://rustsec.org/advisories/RUSTSEC-2022-0040"
      "https://rustsec.org/advisories/RUSTSEC-2023-0018"
      "https://rustsec.org/advisories/RUSTSEC-2020-0071"
      "https://rustsec.org/advisories/RUSTSEC-2021-0124"
    ];
    longDescription = ''
      Chit helps answer these questions:

      * Who wrote this crate? What else did they write?
      * What alternatives are there?
      * How old is this crate?
      * What versions are there? When did they come out?
      * What are the downloads over time?
      * Should i use this crate?
      * How mature is it?
    '';
    homepage = "https://github.com/peterheesterman/chit";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
