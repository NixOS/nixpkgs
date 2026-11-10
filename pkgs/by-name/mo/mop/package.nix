{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "mop";
  version = "0-unstable-2025-12-20";

  src = fetchFromGitHub {
    owner = "mop-tracker";
    repo = "mop";
    rev = "64f37500a195d9c4e01eb3a97199b00515e9fd7a";
    hash = "sha256-j6+bzWfYTBMjgJbyd6JQno2eFTUGHYAv8c4x1Ocp878=";
  };

  vendorHash = "sha256-Jq6SMnCUvuccEP85x1EEYnafUEeBT+AmqeikFvesMYY=";

  postPatch = ''
    # unsafe.Slice requires go1.17 or later
    substituteInPlace go.mod --replace-fail 'go 1.15' 'go 1.17'
    # go says: github.com/rivo/uniseg@v0.2.0: is marked as explicit in vendor/modules.txt, but not explicitly required in go.mod
    # so need to explicitly require it
    echo 'require github.com/rivo/uniseg v0.2.0' >> go.mod
  '';

  meta = {
    description = "Simple stock tracker implemented in go";
    homepage = "https://github.com/mop-tracker/mop";
    license = lib.licenses.mit;
    mainProgram = "mop";
  };
}
