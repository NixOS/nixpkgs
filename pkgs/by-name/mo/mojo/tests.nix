{
  finalPackage,
  patchelf,
  runCommand,
  shell,
}:

{
  version = runCommand "mojo-version" { } ''
    export HOME=$TMPDIR
    ${finalPackage}/bin/mojo --version | grep -F '${finalPackage.version}'
    touch $out
  '';

  hello-world = runCommand "mojo-hello-world" { } ''
    export HOME=$TMPDIR
    cat > hello.mojo <<'EOF'
    def main():
        print("Hello from Mojo!")
    EOF

    ${finalPackage}/bin/mojo hello.mojo > interpreted
    grep -Fx 'Hello from Mojo!' interpreted

    ${finalPackage}/bin/mojo build hello.mojo -o hello
    ./hello > compiled
    grep -Fx 'Hello from Mojo!' compiled

    touch $out
  '';

  cuda-codegen = runCommand "mojo-cuda-codegen" { } ''
    export HOME=$TMPDIR
    cat > cuda-kernel.mojo <<'EOF'
    from max.gpu.host import DeviceContext
    from std.gpu import thread_idx


    def kernel():
        print(thread_idx.x)


    def main() raises:
        with DeviceContext() as ctx:
            ctx.enqueue_function[kernel](grid_dim=1, block_dim=1)
    EOF

    ${finalPackage}/bin/mojo build cuda-kernel.mojo \
      --target-accelerator sm_75 \
      --emit asm \
      -o cuda-kernel.s
    ptx=$(find . -maxdepth 1 -name 'cuda-kernel_*.ptx' -print -quit)
    test -n "$ptx"
    grep -Fx '.target sm_75' "$ptx"
    grep -F '.visible .entry' "$ptx"
    grep -F '%tid.x' "$ptx"

    touch $out
  '';

  driver-runpath = runCommand "mojo-driver-runpath" { nativeBuildInputs = [ patchelf ]; } ''
    elfCount=0
    find ${finalPackage} -type f -print0 > files
    while IFS= read -r -d "" file; do
      if rpath=$(patchelf --print-rpath "$file" 2>/dev/null); then
        echo "$rpath" | grep -F '/run/opengl-driver/lib'
        elfCount=$((elfCount + 1))
      fi
    done < files
    test "$elfCount" -gt 0
    touch $out
  '';

  no-gpu = runCommand "mojo-no-gpu" { } ''
    export HOME=$TMPDIR
    if ${finalPackage}/bin/gpu-query > gpu-query-output 2>&1; then
      echo "gpu-query unexpectedly found a GPU" >&2
      exit 1
    else
      status=$?
    fi
    test "$status" -eq 2
    grep -F 'No supported "gpu" device available.' gpu-query-output
    grep -F 'GPU is not present' gpu-query-output
    touch $out
  '';

  tooling = runCommand "mojo-tooling" { } ''
    export HOME=$TMPDIR
    ${finalPackage}/bin/mojo-lldb --version | grep -F 'lldb version'
    ${finalPackage}/bin/mojo-lsp-server --version

    request='{"seq":1,"type":"request","command":"initialize","arguments":{"adapterID":"mojo"}}'
    printf 'Content-Length: %d\r\n\r\n%s' "''${#request}" "$request" \
      | ${finalPackage}/bin/lldb-dap > dap-response
    grep -qF '"command":"initialize"' dap-response
    grep -qF '"success":true' dap-response

    touch $out
  '';

  formatter = runCommand "mojo-formatter" { } ''
    export HOME=$TMPDIR
    cat > unformatted.mojo <<'EOF'
    def main( ):
      print( "formatted" )
    EOF

    cat > custom-mblack <<EOF
    #!${shell}
    touch "$TMPDIR/formatter-override-used"
    EOF
    chmod +x custom-mblack
    MODULAR_MOJO_MAX_MBLACK_PATH=$PWD/custom-mblack \
      ${finalPackage}/bin/mojo format unformatted.mojo
    test -e "$TMPDIR/formatter-override-used"

    ${finalPackage}/bin/mojo format unformatted.mojo
    grep -Fx 'def main():' unformatted.mojo

    mkdir pythonpath
    cat > pythonpath/sitecustomize.py <<EOF
    from pathlib import Path
    Path("$TMPDIR/pythonpath-preserved").touch()
    EOF
    PYTHONPATH=$PWD/pythonpath ${finalPackage}/bin/mblack --version
    test -e "$TMPDIR/pythonpath-preserved"

    touch $out
  '';
}
