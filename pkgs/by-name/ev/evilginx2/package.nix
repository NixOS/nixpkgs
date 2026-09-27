{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "evilginx2";
  version = "3.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kgretzky";
    repo = "evilginx2";
    tag = "v${finalAttrs.version}";
    # Sử dụng mã hash chính xác bạn vừa cung cấp
    hash = "sha256-/UQgoT/AO3TpkV5VF5ybVdVSJHLwX2d9k5w579sWEUE=";
  };

  # Vì bạn chưa cung cấp vendorHash của Go dependencies,
  # dòng này tạm để fakeHash để Nix tải các gói Go về và tạo module bọc sau.
  vendorHash = null;

  # Thêm công cụ tạo shortcut/wrapper script của Nix
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # 1. Tạo thư mục share để lưu trữ các phishlets gốc đi kèm mã nguồn
    mkdir -p $out/share/evilginx
    cp -r phishlets $out/share/evilginx/

    # 2. Tạo wrapper script tự động chèn tham số đường dẫn phishlets mặc định
    wrapProgram $out/bin/evilginx2 \
      --add-flags "-p $out/share/evilginx/phishlets"
  '';

  meta = with lib; {
    description = "Standalone man-in-the-middle attack framework";
    homepage = "https://github.com/kgretzky/evilginx2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Duckii92 ];
    platforms = platforms.linux;
  };
})
