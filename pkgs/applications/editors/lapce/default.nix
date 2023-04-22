{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, rustPlatform
, cmake
, pkg-config
, perl
, fontconfig
, copyDesktopItems
, makeDesktopItem
, glib
, gtk3
, openssl
, libobjc
, Security
, CoreServices
, ApplicationServices
, Carbon
, AppKit
, wrapGAppsHook
, gobject-introspection
}:

rustPlatform.buildRustPackage rec {
  pname = "lapce";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "lapce";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xq/xLoVvETGp+Yxlh3wbg74R+U9eqjFOKJyt/AUybvU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "druid-0.7.0" = "sha256-PJH+Y5PScM6KnPeb5lBLKpqe9nbG3bXIJK2y4V1IM9o=";
      "druid-derive-0.4.0" = "sha256-PJH+Y5PScM6KnPeb5lBLKpqe9nbG3bXIJK2y4V1IM9o=";
      "druid-shell-0.7.0" = "sha256-PJH+Y5PScM6KnPeb5lBLKpqe9nbG3bXIJK2y4V1IM9o=";
      "font-kit-0.11.0" = "sha256-MsUbFhWd3GdqchzwrRPuzpz3mNYde00HwA9EIRBc2SQ=";
      "fount-0.1.0" = "sha256-ptPnisGuzip3tQUuwtPU+ETiIzxMvIgAvlIGyGw/4wI=";
      "human-sort-0.2.2" = "sha256-tebgIJGXOY7pwWRukboKAzXY47l4Cn//0xMKQTaGu8w=";
      "parley-0.1.0" = "sha256-9xT+bhcZSBxQp10cbxQlqiG4D4NxaTkAxfgaHX0cqX4=";
      "piet-wgpu-0.1.0" = "sha256-SOycknxo6wMDy/2D3cxsngI0MZO78B5QkhdCkvCkFyU=";
      "psp-types-0.1.0" = "sha256-7scU/eR6S2hVS6UKoFmZP901DMZEEho35nVEuQJERR0=";
      "structdesc-0.1.0" = "sha256-4j6mJ1H5hxJXr7Sz0UsZxweyAm9sYuxjq8yg3ZlpksI=";
      "swash-0.1.4" = "sha256-oPjQF/nKnoHyed+4SZcc4zlc/I+0J6/DuigbHglQPMA=";
      "tree-sitter-bash-0.19.0" = "sha256-gTsA874qpCI/N5tmBI5eT8KDaM25gXM4VbcCbUU2EeI=";
      "tree-sitter-c-sharp-0.20.0" = "sha256-4R6+15ZbtC/LtSHpk7DqcMiFYjht+062Av31spK07rc=";
      "tree-sitter-clojure-0.1.0" = "sha256-qeTQgJ3DAlqhRlATB34aPNzAgKOyIaxfKiZP9Z3Mx2k=";
      "tree-sitter-css-0.19.0" = "sha256-xXDTi9HL46qHoeyf2ZQJRCIYCY4vWBmTBkt55EewgmQ=";
      "tree-sitter-d-0.3.2" = "sha256-oWbggHlWVxc5QsHDvOVcWvjykLPmFuuoxkqgen7He4A=";
      "tree-sitter-dart-0.0.1" = "sha256-JW9Hdzm/Sb56od+K/Wf0IlcfpgiEVY5e3ovOtMEeqpQ=";
      "tree-sitter-dockerfile-0.1.0" = "sha256-sSkAR6CZ9MnjeggaQ3F0aG4m0oKKSa866EXQDgm6k3Q=";
      "tree-sitter-elixir-0.19.0" = "sha256-5nopPahI6VDxu9z2lKaXWMPZ+1EWYRM2S9k3cfRrxGM=";
      "tree-sitter-erlang-0.0.1" = "sha256-6eiRiTTPdMBRsxVHIHYuw0sIfRDvP4pZIEyckoo304Q=";
      "tree-sitter-glimmer-0.0.1" = "sha256-qQQ94F/CMx0cMhqqpY0xkMi10Yx+XG1YiT+if6laJvM=";
      "tree-sitter-glsl-0.1.3" = "sha256-k37NkUjYPzZnE21EYPBX4CAFdmZzJzy5BOJU+VjpcA4=";
      "tree-sitter-haskell-0.14.0" = "sha256-94zxdt3JjC3iki639taHYmRwQIzOlOM6H9C3sKnRj/o=";
      "tree-sitter-haxe-0.2.2" = "sha256-yUzJDaAu2kTompR6W0UDRgld/mveaDoj9bdE9Bz9GwI=";
      "tree-sitter-hcl-0.0.1" = "sha256-GWUOATMa6ANnhH5k+P9GcCNQQnhqpyfblUG90rQN0iw=";
      "tree-sitter-java-0.20.0" = "sha256-tGBi6gJJIPpp6oOwmAQdqBD6eaJRBRcYbWtm1BHsgBA=";
      "tree-sitter-json-0.20.0" = "sha256-pXa6WFJ4wliXHBiuHuqtAFWz+OscTOxbna5iymS547w=";
      "tree-sitter-julia-0.19.0" = "sha256-z+E3sYS9fMBWlSmy/3wiQRzhrYhhNK5xH6MK1FroMi8=";
      "tree-sitter-kotlin-0.2.11" = "sha256-aRMqhmZKbKoggtBOgtFIq0xTP+PgeD3Qz6DPJsAFPRQ=";
      "tree-sitter-latex-0.2.0" = "sha256-0n42ZrlQdo1IbrURVJkcKV2JeQ7jUI2eSW7dkC1aXH4=";
      "tree-sitter-lua-0.0.12" = "sha256-0gViT7PjduQsTTi4e0VVUFiXJjmrjFBnWdGY0B4iS/0=";
      "tree-sitter-md-0.1.2" = "sha256-gKbjAcY/x9sIxiG7edolAQp2JWrx78mEGeCpayxFOuE=";
      "tree-sitter-nix-0.0.1" = "sha256-BYAVY0BISrJSwIMvLa/4QrkWdzMs36ZEz96w/CxWVVo=";
      "tree-sitter-ocaml-0.20.0" = "sha256-gTmRBFFCBrA48Yn1MO2mMQPpa6u3uv5McC4BDuMXKuM=";
      "tree-sitter-php-0.19.1" = "sha256-Lg4gEi6bCYosakr2McmgOwGHsmsVSjD+oyG6XNTd0j0=";
      "tree-sitter-protobuf-0.0.1" = "sha256-h86NQAIRU+mUroa0LqokMtEVd7U5BXo/DADc2UUZQzI=";
      "tree-sitter-ql-0.19.0" = "sha256-2QOtNguYAIhIhGuVqyx/33gFu3OqcxAPBZOk85Q226M=";
      "tree-sitter-ruby-0.19.0" = "sha256-BjdgNxXoaZ+nYrszd8trL0Cu4hnQNZkSWejTThkAn0o=";
      "tree-sitter-scheme-0.2.0" = "sha256-K3+zmykjq2DpCnk17Ko9LOyGQTBZb1/dgVXIVynCYd4=";
      "tree-sitter-scss-0.0.1" = "sha256-zGnPZbdRfFvDmbfNMWxTpKCp0/Yl1WqlLjw05jtVofM=";
      "tree-sitter-sql-0.0.2" = "sha256-PZSJ/8N/HNskFnkfqN11ZBOESXHGGGCPG/yET832hlE=";
      "tree-sitter-svelte-0.10.2" = "sha256-ACRpn1/2d6/ambLvr0xr7kT9gTzFFHXtvbQRTxEoet0=";
      "tree-sitter-wgsl-0.0.1" = "sha256-x42qHPwzv3uXVahHE9xYy3RkrYFctJGNEJmu6w1/2Qo=";
      "tree-sitter-xml-0.0.1" = "sha256-3DwRrAkk0OU2bOxBYSPpUQm2dxg1AYosbV6HXfYax/Y=";
      "tree-sitter-yaml-0.0.1" = "sha256-bQ/APnFpes4hQLv37lpoADyjXDBY7J4Zg+rLyUtbra4=";
      "tree-sitter-zig-0.0.1" = "sha256-E0q3nWsAMXBVM5LkOfrfBJyV9jQPJjiCSnD2ikXShFc=";
      "wasi-experimental-http-wasmtime-0.10.0" = "sha256-vV2cwA+vxWcrozXparleZUqKxp2DDkaRJFOAT0m2uWo=";
    };
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    copyDesktopItems
    wrapGAppsHook # FIX: No GSettings schemas are installed on the system
    gobject-introspection
  ];

  # Get openssl-sys to use pkg-config
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [
    glib
    gtk3
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    fontconfig
  ] ++ lib.optionals stdenv.isDarwin [
    libobjc
    Security
    CoreServices
    ApplicationServices
    Carbon
    AppKit
  ];

  postInstall = ''
    install -Dm0644 $src/extra/images/logo.svg $out/share/icons/hicolor/scalable/apps/lapce.svg
  '';

  desktopItems = [ (makeDesktopItem {
    name = "lapce";
    exec = "lapce %F";
    icon = "lapce";
    desktopName = "Lapce";
    comment = meta.description;
    genericName = "Code Editor";
    categories = [ "Development" "Utility" "TextEditor" ];
  }) ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Lightning-fast and Powerful Code Editor written in Rust";
    homepage = "https://github.com/lapce/lapce";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ elliot ];
  };
}
