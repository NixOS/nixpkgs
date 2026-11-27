{
  lib,
  fetchFromGitHub,
  leanPackages,
}:

leanPackages.buildLakePackage (finalAttrs: {
  pname = "lean4lean";
  version = "0-unstable-2026-09-09";

  src = fetchFromGitHub {
    owner = "Kha";
    repo = "lean4lean";
    # https://github.com/leanprover/lean4/blob/v{version}/src/CMakeLists.txt
    tag = "lean4-bundle-4.35";
    hash = "sha256-VTxvXgJrHeY4ZFRHuyCVFS+iMhTIgTn2h9CWK3BuA9k=";
  };

  patches = [
    ./0001-fix-fix-build.patch
  ];

  leanDeps = with leanPackages; [
    batteries
    lean4export
  ];

  # bwrap: Can't mount on symlink destination
  postInstall = ''
    rm $out/bin/lean4lean
    ln $out/.lake/build/bin/lean4lean -T $out/bin/lean4lean
  '';

  meta = with lib; {
    description = "Lean 4 kernel written in Lean 4";
    homepage = "https://github.com/Kha/lean4lean";
    license = licenses.asl20;
    mainProgram = "lean4lean";
    maintainers = with maintainers; [ stephen-huan ];
  };
})
