{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "jsluice";
  version = "0-unstable-2024-01-10";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = "jsluice";
    rev = "0ddfab153e060a9eeaded4d8669233f7c071e7e4";
    hash = "sha256-8BgpUvdHcooB2Kll91OCWKV6mMZVyyxkfYQx/vWEo0o=";
  };

  vendorHash = "sha256-uecg0Oi1VCCi/pZqtdiKmJNKhpqDrhxe/HpWGymKlow=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool for extracting URLs, paths, secrets, and other data from JavaScript source code";
    homepage = "https://github.com/BishopFox/jsluice";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
