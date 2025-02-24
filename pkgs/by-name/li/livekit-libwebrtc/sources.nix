{
  fetchFromGitHub,
  fetchFromGitiles,
  fetchgit,
  fetchurl,
  runCommand,
  lib,
}:
let
  sourceDerivations = {
    "src" = fetchFromGitHub {
      owner = "webrtc-sdk";
      repo = "webrtc";
      rev = "dac8015ce039c8658706b222746808f01968256b";
      hash = "sha256-T5syfRzX/LfvEllVurzZPKffkciTd2inUEC2py78ZPA=";
    };
    "src/base" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/src/base";
      rev = "fe22033c21d399a340b3f4604722463d9da25c6e";
      hash = "sha256-iqtcXEtmCNioKRxfTCwiU/NG0xlQ1R/6GE1M6qC0XTU=";
    };
    "src/build" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/src/build";
      rev = "a9d28a095c8b349f8319ee0d241a78e2c849928f";
      hash = "sha256-5NguoLWm6v68fpyHK6SYbM6vHdaOT0quks5/SPW0XOI=";
    };
    "src/buildtools" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/src/buildtools";
      rev = "539a6f68735c631f57ae33096e9e7fc059e049cf";
      hash = "sha256-1u4BQqXcW4Z9LPx7lMjBLK8ouKkyb576FRvB2LGwf7Q=";
    };
    "src/testing" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/src/testing";
      rev = "ee4801b4e9c2d945fff5236d8518511e6c00a29e";
      hash = "sha256-xUfPwWVPoLxlCWHFKLWtRC1kVJgLgcvSoXPYmrseCXE=";
    };
    "src/third_party" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/src/third_party";
      rev = "4f8bf4c6885ab577c7577c4cdd11d04eaf78e9ca";
      hash = "sha256-4ehEerUw9IvghdPPrrh+WCm/XEpVe5PjjIRbQZpIsbY=";
    };
    "src/buildtools/clang_format/script" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/clang/tools/clang-format";
      rev = "f97059df7f8b205064625cdb5f97b56668a125ef";
      hash = "sha256-IL6ReGM6+urkXfGYe1BBOv+0XgCZv5i3Lib1q9COhig=";
    };
    "src/buildtools/third_party/libc++/trunk" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxx";
      rev = "bff81b702ff4b7f74b1c0ed02a4bcf6c2744a90b";
      hash = "sha256-i/FGU9F7HlGJJuwoFMV4V05pf4pvsqNxrPBN223YjZQ=";
    };
    "src/buildtools/third_party/libc++abi/trunk" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxxabi";
      rev = "307bd163607c315d46103ebe1d68aab44bf93986";
      hash = "sha256-Zka8AHFtHA4AC/Pbzc3pVqz/k2GYZYc8CeP1IXxGBUM=";
    };
    "src/buildtools/third_party/libunwind/trunk" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libunwind";
      rev = "2795322d57001de8125cfdf18cef804acff69e35";
      hash = "sha256-u6FMD83JBBusQuWU7Hx5HREvLIFWUA4iN4If8poaHbE=";
    };
    "src/third_party/boringssl/src" = fetchFromGitiles {
      url = "https://boringssl.googlesource.com/boringssl";
      rev = "6776d5cd8fcdf6c5e05bae2d655076dbeaa56103";
      hash = "sha256-KvQhpkn1pGQ/xPbkHcGgTTvL3GGRL1TfdSPYgfNn5bU=";
    };
    "src/third_party/breakpad/breakpad" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/breakpad/breakpad";
      rev = "9bf8d1ec526cec139b2d3fba148ce81ccf2cceab";
      hash = "sha256-c3/ksp01+cmSyzaD5SF0Lnnw+t78RwZAKCJnwg1NGXU=";
    };
    "src/third_party/catapult" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/catapult";
      rev = "cae7ec667dee9f5c012b54ee9ffee94eb7beda14";
      hash = "sha256-vK7rlGshfzPzaEdAxlP5vQ4USR/fC3BzPCh/rn0aAf4=";
    };
    "src/third_party/ced/src" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/google/compact_enc_det";
      rev = "ba412eaaacd3186085babcd901679a48863c7dd5";
      hash = "sha256-ySG74Rj2i2c/PltEgHVEDq+N8yd9gZmxNktc56zIUiY=";
    };
    "src/third_party/colorama/src" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/colorama";
      rev = "3de9f013df4b470069d03d250224062e8cf15c49";
      hash = "sha256-6ZTdPYSHdQOLYMSnE+Tp7PgsVTs3U2awGu9Qb4Rg/tk=";
    };
    "src/third_party/crc32c/src" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/google/crc32c";
      rev = "fa5ade41ee480003d9c5af6f43567ba22e4e17e6";
      hash = "sha256-urg0bmnfMfHagLPELp4WrNCz1gBZ6DFOWpDue1KsMtc=";
    };
    "src/third_party/depot_tools" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/tools/depot_tools";
      rev = "6e714e6dfe62110c95fafed4bdeb365a69c6a77e";
      hash = "sha256-7jPow77ejToE55KvQ7/eO0alMdMHcypfSyPceFAbZkw=";
    };
    "src/third_party/ffmpeg" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/third_party/ffmpeg";
      rev = "8d21d41d8bec5c0b266ee305d1a708dc5c23b594";
      hash = "sha256-UjrZJBtOQiiqxtLb8x24axord3OFvyCcRcgDwiYE/jw=";
    };
    "src/third_party/flatbuffers/src" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/google/flatbuffers";
      rev = "a56f9ec50e908362e20254fcef28e62a2f148d91";
      hash = "sha256-OQ8E+i30WRz/lPJmVDiF7+TPo4gZVu2Of9loxz3tswI=";
    };
    "src/third_party/grpc/src" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/grpc/grpc";
      rev = "822dab21d9995c5cf942476b35ca12a1aa9d2737";
      hash = "sha256-64JEVCx/PCM0dvv7kAQvSjLc0QbRAZVBDzwD/FAV6T8=";
    };
    "src/third_party/fontconfig/src" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/fontconfig";
      rev = "06929a556fdc39c8fe12965b69070c8df520a33e";
      hash = "sha256-0R+FEhtGXFiQWHEPRrJqaBW1JVfCojYI4NPDvYMBhoU=";
    };
    "src/third_party/freetype/src" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/src/third_party/freetype2";
      rev = "9806414c15230d253d5219ea0dafeddb717307b1";
      hash = "sha256-UbWtRb24U7Cv+PecVtoNG33Q1ItmkvssmW8Bh8qlFvA=";
    };
    "src/third_party/harfbuzz-ng/src" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/harfbuzz/harfbuzz";
      rev = "2822b589bc837fae6f66233e2cf2eef0f6ce8470";
      hash = "sha256-qwtRORl/Pu4M9EvW8MdK8onFMCw/4+57FEBjoNt4qoY=";
    };
    "src/third_party/google_benchmark/src" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/google/benchmark";
      rev = "b177433f3ee2513b1075140c723d73ab8901790f";
      hash = "sha256-h2ryAQAuHI54Cni88L85e7Np4KATGVTRdDcmUvCNeWc=";
    };
    "src/third_party/gtest-parallel" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/google/gtest-parallel";
      rev = "f4d65b555894b301699c7c3c52906f72ea052e83";
      hash = "sha256-dzWXJHPb8RHqxoi/gA9npwnjAsT8gg7A90g/dx8LVwQ=";
    };
    "src/third_party/googletest/src" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/google/googletest";
      rev = "af29db7ec28d6df1c7f0f745186884091e602e07";
      hash = "sha256-VYRjcM3dDY2FarviXyFMgSkXCqKfWXwtGAj2Msgm7zg=";
    };
    "src/third_party/icu" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/deps/icu";
      rev = "d8daa943f64cd5dd2a55e9baf2e655ab4bfa5ae9";
      hash = "sha256-47Xxb5IFbRmdO3oADjn13fm7aIYFXh2R4YVZIJAy22U=";
    };
    "src/third_party/jsoncpp/source" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/open-source-parsers/jsoncpp";
      rev = "42e892d96e47b1f6e29844cc705e148ec4856448";
      hash = "sha256-bSLNcoYBz3QCt5VuTR056V9mU2PmBuYBa0W6hFg2m8Q=";
    };
    "src/third_party/libFuzzer/src" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/llvm-project/compiler-rt/lib/fuzzer";
      rev = "debe7d2d1982e540fbd6bd78604bf001753f9e74";
      hash = "sha256-HG3KHhKQnr4hdnUK/2QhcxRdNxh38fhU54JKKzqZaio=";
    };
    "src/third_party/libjpeg_turbo" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/deps/libjpeg_turbo";
      rev = "aa4075f116e4312537d0d3e9dbd5e31096539f94";
      hash = "sha256-QnXMR9qqRiYfV1sUJvKVvLQ9A022lYKbsrI9HOU9LCs=";
    };
    "src/third_party/libsrtp" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/deps/libsrtp";
      rev = "5b7c744eb8310250ccc534f3f86a2015b3887a0a";
      hash = "sha256-pfLFh2JGk/g0ZZxBKTaYW9/PBpkCm0rtJeyNePUMTTc=";
    };
    "src/third_party/dav1d/libdav1d" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/videolan/dav1d";
      rev = "d426d1c91075b9c552b12dd052af1cd0368f05a2";
      hash = "sha256-FivzwqCvlY89q2znGvfNks+hje/iUFHcKPb19FyAZhM=";
    };
    "src/third_party/libaom/source/libaom" = fetchFromGitiles {
      url = "https://aomedia.googlesource.com/aom";
      rev = "5a0903824082f41123e8365b5b99ddb6ced8971c";
      hash = "sha256-j8b0xM7hHNqYIeUQjf+c7LyzcfZVJx64Xqo9gIRtsYU=";
    };
    "src/third_party/perfetto" = fetchFromGitiles {
      url = "https://android.googlesource.com/platform/external/perfetto";
      rev = "20b114cd063623e63ef1b0a31167d60081567e51";
      hash = "sha256-6BpUd+BplRR/0eUIYz5SehzrpNHPfUm2Qv6U1+Mxy8g=";
    };
    "src/third_party/libvpx/source/libvpx" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/webm/libvpx";
      rev = "7aaffe2df4c9426ab204a272ca5ca52286ca86d4";
      hash = "sha256-Uis24FzUtM38ktPG/wDJLiHZYmpmYFGbuQ/SWnmZJSA=";
    };
    "src/third_party/libyuv" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/libyuv/libyuv";
      rev = "77c2121f7e6b8e694d6e908bbbe9be24214097da";
      hash = "sha256-LLmTW05GxoXgNkLRHp3e6gb7glMgJo1moc6lPLVHk6w=";
    };
    "src/third_party/lss" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/linux-syscall-support";
      rev = "ce877209e11aa69dcfffbd53ef90ea1d07136521";
      hash = "sha256-hE8uZf9Fst66qJkoVYChiB8G41ie+k9M4X0W+5JUSdw=";
    };
    "src/third_party/nasm" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/deps/nasm";
      rev = "7fc833e889d1afda72c06220e5bed8fb43b2e5ce";
      hash = "sha256-L+b3X3vsfpY6FSlIK/AHhxhmq2cXd50vND6uT6yn8Qs=";
    };
    "src/third_party/openh264/src" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/cisco/openh264";
      rev = "09a4f3ec842a8932341b195c5b01e141c8a16eb7";
      hash = "sha256-J7Eqe2QevZh1xfap19W8AVCcwfRu7ztknnbKFJUAH1c=";
    };
    "src/tools" = fetchFromGitiles {
      url = "https://chromium.googlesource.com/chromium/src/tools";
      rev = "bafae7909cbbcd277d29c0da0809001a8d6f4a14";
      hash = "sha256-MK5M9RrX+cX4S7vsMgNVQ2YkNbEuvizKueuc1mA5jyU=";
    };
  };
  namedSourceDerivations = builtins.mapAttrs (
    path: drv:
    drv.overrideAttrs {
      name = lib.strings.sanitizeDerivationName path;
    }
  ) sourceDerivations;
in
runCommand "combined-sources" { } (
  lib.concatLines (
    [ "mkdir $out" ]
    ++ (lib.mapAttrsToList (path: drv: ''
      mkdir -p $out/${path}
      cp --no-preserve=mode --reflink=auto -rfT ${drv} $out/${path}
    '') namedSourceDerivations)
  )
)
