{
  comma,
  fetchFromGitHub,
  fzy,
  lib,
  nix-index-unwrapped,
  nix,
  rustPlatform,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "comma";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v${version}";
    hash = "sha256-JogC9NIS71GyimpqmX2/dhBX1IucK395iWZVVabZxiE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Cd4WaOG+OkCM4Q1K9qVzMYOjSi9U8W82JypqUN20x9w=";

  postPatch = ''
    substituteInPlace ./src/main.rs \
      --replace-fail '"nix-locate"' '"${lib.getExe' nix-index-unwrapped "nix-locate"}"' \
      --replace-fail '"nix"' '"${lib.getExe nix}"' \
      --replace-fail '"nix-env"' '"${lib.getExe' nix "nix-env"}"' \
      --replace-fail '"fzy"' '"${lib.getExe fzy}"'
  '';

  postInstall = ''
    ln -s $out/bin/comma $out/bin/,

    mkdir -p $out/etc/profile.d
    mkdir -p $out/etc/nushell
    mkdir -p $out/etc/fish/functions

    cp $src/etc/comma-command-not-found.sh $out/etc/profile.d
    cp $src/etc/comma-command-not-found.nu $out/etc/nushell
    cp $src/etc/comma-command-not-found.fish $out/etc/fish/functions

    patchShebangs $out/etc/profile.d/comma-command-not-found.sh
    substituteInPlace \
      "$out/etc/profile.d/comma-command-not-found.sh" \
      "$out/etc/nushell/comma-command-not-found.nu" \
      "$out/etc/fish/functions/comma-command-not-found.fish" \
      --replace-fail "comma --ask" "$out/bin/comma --ask"
  '';

  passthru.tests = {
    version = testers.testVersion { package = comma; };
  };

  meta = with lib; {
    homepage = "https://github.com/nix-community/comma";
    description = "Runs programs without installing them";
    license = licenses.mit;
    mainProgram = "comma";
    maintainers = with maintainers; [ artturin ];
  };
}
