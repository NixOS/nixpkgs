{ fetchgit
}:
rec {
  revision = "5e296cb4749c3b48653eb6e5888947ad4aa86d3a";
  sources = {
    native_client = fetchgit
    {
      "url" = "https://chromium.googlesource.com/native_client/src/native_client.git";
      "rev" = "5e296cb4749c3b48653eb6e5888947ad4aa86d3a";
      "sha256" = "1y4hg9rbx975ryv3g3znlljc0hih3zx58hrsiznrhjcyvx9v6kfd";
    };
    breakpad = fetchgit
    {
      "url" = "https://chromium.googlesource.com/breakpad/breakpad.git";
      "rev" = "5f638d532312685548d5033618c8a36f73302d0a";
      "sha256" = "02ysq9pjkhkka7kvq8x3979xwfc14cqfhzm1k5bq89a8bg0a71z0";
    };
    third_party = fetchgit
    {
      "url" = "https://chromium.googlesource.com/native_client/src/third_party.git";
      "rev" = "d4e38e5faf600b39649025e5605d6e7f94518ea7";
      "sha256" = "1pg5fshw68casrxmd7dx821fx79azj6vrxrmq1zsmp8wp4d2z2kf";
    };
    binutils = fetchgit
    {
      "url" = "https://chromium.googlesource.com/native_client/nacl-binutils.git";
      "rev" = "03d37f8de86d6f876979760502021c003523bdef";
      "sha256" = "0az6d2zvi0aizjbf0pjgwr1nm3vzs1njbj694d58x8d5xl9bkwvn";
    };
    binutils_x86 = fetchgit
    {
      "url" = "https://chromium.googlesource.com/native_client/nacl-binutils.git";
      "rev" = "1d8592cc9f02cc9aeaef992c296376a8fd4c8761";
      "sha256" = "1gg3j04v005g1bg3h7iahk3gsylrhyxd6bfa74gfkp2nzfbxcdp4";
    };
    clang = fetchgit
    {
      "url" = "https://chromium.googlesource.com/native_client/pnacl-clang.git";
      "rev" = "ce163fdd0f16b4481e5cf77a16d45e9b4dc8300e";
      "sha256" = "153jmza9aq1nvk04hvsj99vq57h5agr417glm79zfrgp8drzy2an";
    };
    llvm = fetchgit
    {
      "url" = "https://chromium.googlesource.com/native_client/pnacl-llvm.git";
      "rev" = "83991f993fea6cd9c515df12c3270ab9c0746215";
      "sha256" = "12yja782z6dqfq46c6011fssvx3lypdgpjvmza5qalkd0i5ap9p6";
    };
    gcc = fetchgit
    {
      "url" = "https://chromium.googlesource.com/native_client/pnacl-gcc.git";
      "rev" = "574429118e460375c377728420c43aad4a3103dc";
      "sha256" = "058gpiwziz0flpj0h3x0bdv2gi1wbjm9nybl34f0wf6rllbnapvf";
    };
    libcxx = fetchgit
    {
      "url" = "https://chromium.googlesource.com/native_client/pnacl-libcxx.git";
      "rev" = "91a5433c0c5e891098987276f3c6e98fe5c1b86a";
      "sha256" = "1rsnvpvd901yzfqkn7l5990mpg0z01v15yfck2b5wpw66w2i4vz7";
    };
    libcxxabi = fetchgit
    {
      "url" = "https://chromium.googlesource.com/native_client/pnacl-libcxxabi.git";
      "rev" = "de05b63efeb5df83abe927c08f330c35995c82a7";
      "sha256" = "0phbw6c999mpbx0cyw7g3xjf4crk0l2ng5s9h135lkxc54viwa2f";
    };
    nacl_newlib = fetchgit
    {
      "url" = "https://chromium.googlesource.com/native_client/nacl-newlib.git";
      "rev" = "784956835fd318fa64e513ead7774d897386a7be";
      "sha256" = "18aw53jkz5llynr04gisdzdggwapvp7pksg31w40crbvj02vznjb";
    };
    compiler_rt = fetchgit
    {
      "url" = "https://chromium.googlesource.com/native_client/pnacl-compiler-rt.git";
      "rev" = "9ded361c356ebc38a115e8134b8f7ca4f1d61eb0";
      "sha256" = "0y1rkbnrjgg1711yvm2hr5pnbb943nbwmiwn56051n4ybvly321n";
    };
    subzero = fetchgit
    {
      "url" = "https://chromium.googlesource.com/native_client/pnacl-subzero.git";
      "rev" = "c2ee36a65cb3ea176210301bb73dfda97ef229c9";
      "sha256" = "1242gn4dyqnbcvm1s4zj0n9kzdphmm97k1rp8ds5i8vqjrrwrr42";
    };
  };
  copySources = ''
    cp -prd ${sources.native_client} native_client
    chmod +wx native_client/toolchain_build
    mkdir native_client/toolchain_build/src

    ln -s ${sources.breakpad} breakpad
    ln -s ${sources.third_party} third_party
    cp -prd ${sources.binutils} native_client/toolchain_build/src/binutils
    cp -prd ${sources.binutils_x86} native_client/toolchain_build/src/binutils-x86
    cp -prd ${sources.clang} native_client/toolchain_build/src/clang
    cp -prd ${sources.llvm} native_client/toolchain_build/src/llvm
    cp -prd ${sources.gcc} native_client/toolchain_build/src/pnacl-gcc
    cp -prd ${sources.libcxx} native_client/toolchain_build/src/libcxx
    cp -prd ${sources.libcxxabi} native_client/toolchain_build/src/libcxxabi
    cp -prd ${sources.nacl_newlib} native_client/toolchain_build/src/pnacl-newlib
    cp -prd ${sources.compiler_rt} native_client/toolchain_build/src/compiler-rt
    cp -prd ${sources.subzero} native_client/toolchain_build/src/subzero

    chmod -R u+w native_client
    patchShebangs native_client

    native_client/src/trusted/service_runtime/export_header.py \
        native_client/src/trusted/service_runtime/include \
        native_client/toolchain_build/src/pnacl-newlib/newlib/libc/sys/nacl

    cp native_client/src/untrusted/pthread/pthread.h native_client/toolchain_build/src/pnacl-newlib/newlib/libc/include/
    cp native_client/src/untrusted/pthread/semaphore.h native_client/toolchain_build/src/pnacl-newlib/newlib/libc/include/
  '';
}
