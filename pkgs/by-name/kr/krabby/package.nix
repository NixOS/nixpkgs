{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "krabby";
  version = "0.2.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-YEY4bUZV9BpyVXzEGvnLyfG0GdE3xMN9tHlsg6RqMkk=";
  };

  cargoHash = "sha256-6NV+kqnloEFTygE5LLuCsgMYXGiDwOTnP6/CK2c9DOs=";

  meta = with lib; {
    description = "Print pokemon sprites in your terminal";
    homepage = "https://github.com/yannjor/krabby";
    changelog = "https://github.com/yannjor/krabby/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ruby0b ];
    mainProgram = "krabby";
  };
}
