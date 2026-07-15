{
  lib,
  rustPlatform,
  fetchFromCodeberg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rusty-diceware";
  version = "0.5.10";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "kakafarm";
    repo = "rusty-diceware";
    rev = "53975f17f5f575720d724035bd715dd2dd75986d";
    hash = "sha256-uSbJFZ0wqo1RbRP9BWiT4cDg9CV/aSYz432a/qUk7qw=";
  };

  cargoHash = "sha256-TCNHtDz7dgUx5lBwwIs67mnQcAZ5Xknc6otpl8zRaVc=";

  meta = {
    description = "Commandline diceware, with or without dice, written in Rustlang";
    homepage = "https://codeberg.org/kakafarm/rusty-diceware";
    changelog = "https://codeberg.org/kakafarm/rusty-diceware/src/branch/master/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      cherrykitten
      kybe236
    ];
    mainProgram = "diceware";
  };
})
