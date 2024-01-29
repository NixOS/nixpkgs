{ stdenv, fetchFromGitHub, unstableGitUpdater }:
stdenv.mkDerivation {
  pname = "yuzu-compatibility-list";
  version = "unstable-2024-01-27";

  src = fetchFromGitHub {
    owner = "flathub";
    repo = "org.yuzu_emu.yuzu";
    rev = "c01bdbbfda3e2558930fcced63b6d02b646f881b";
    hash = "sha256-TDmzBxeJq4gJvU88hJaXN7U3PYOqI1OrkenlH1GJo8g=";
  };

  buildCommand = ''
    cp $src/compatibility_list.json $out
  '';

  passthru.updateScript = unstableGitUpdater {};
}
