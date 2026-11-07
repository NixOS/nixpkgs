{ fetchurl, fetchgit }:
{
  url = {
    "brotli" = {
      file = "v1.1.0.tar.gz";
      src = fetchurl {
        url = "https://github.com/google/brotli/archive/refs/tags/v1.1.0.tar.gz";
        hash = "sha256-5yCmyilCi4A/StFlNxdx9TmPq6OX7fZ3iDehhZnqE/8=";
      };
    };
    # "certifi" -> vendored from nixpkgs' `cacert` instead; see package.nix.
    "cpu_features" = {
      file = "v0.10.1.tar.gz";
      src = fetchurl {
        url = "https://github.com/google/cpu_features/archive/refs/tags/v0.10.1.tar.gz";
        hash = "sha256-UmObOA/O0R1zj4sVHb/uY/uUlXcx0H8ZZsgS5bkMutQ=";
      };
    };
    "curl" = {
      file = "curl-8.14.1.tar.xz";
      src = fetchurl {
        url = "https://github.com/curl/curl/releases/download/curl-8_14_1/curl-8.14.1.tar.xz";
        hash = "sha256-9GGaHiR0xLv+3IinwhkSCcgzS0j6H05T/VhMwS6RIN0=";
      };
    };
    "czmq" = {
      file = "czmq-4.2.1.tar.gz";
      src = fetchurl {
        url = "https://github.com/zeromq/czmq/releases/download/v4.2.1/czmq-4.2.1.tar.gz";
        hash = "sha256-XXIKIEwqWGRdb3ZDrxXVY6cS2tmMnTLB7ZEzd9qmrDk=";
      };
    };
    # "dkjson" -> vendored from nixpkgs' `luajitPackages.dkjson` instead; see package.nix.
    # "dropbear" -> excluded from the "all" target except on CERVANTES/KINDLE/KOBO/POCKETBOOK, same as "openssh"/"tar" above; never built on Darwin.
    # "fbink" -> excluded from the "all" target except on KOBO/POCKETBOOK/REMARKABLE (same cluster as "fbdepth"/"libfbink_input", never separately vendored here); never built on Darwin.
    "freetype2" = {
      file = "VER-2-14-3.tar.gz";
      src = fetchurl {
        url = "https://github.com/freetype/freetype/archive/refs/tags/VER-2-14-3.tar.gz";
        hash = "sha256-3EneawGiZu70h2pN002YQsR10+KP8u/2O9L7dgq1YmE=";
      };
    };
    "fribidi" = {
      file = "fribidi-1.0.16.tar.xz";
      src = fetchurl {
        url = "https://github.com/fribidi/fribidi/releases/download/v1.0.16/fribidi-1.0.16.tar.xz";
        hash = "sha256-GxzeWyNdQEeekb4vDoijCeMhTIq0cOyKJ0TYKlqeoFw=";
      };
    };
    "giflib" = {
      file = "giflib-6.1.3.tar.gz";
      src = fetchurl {
        url = "https://sourceforge.net/projects/giflib/files/giflib-6.x/giflib-6.1.3.tar.gz";
        hash = "sha256-tltmuZ8EJLk1JfmHOG8i/F77naK/ySrUpTIkmq/7qw4=";
      };
    };
    "glib" = {
      file = "glib-2.82.1.tar.xz";
      src = fetchurl {
        url = "https://download.gnome.org/sources/glib/2.82/glib-2.82.1.tar.xz";
        hash = "sha256-R4Y0RAv1LuTsRCjVWHhzmMC+awQ8UhvrMIM0s9tEiaY=";
      };
    };
    "harfbuzz" = {
      file = "harfbuzz-14.2.1.tar.xz";
      src = fetchurl {
        url = "https://github.com/harfbuzz/harfbuzz/releases/download/14.2.1/harfbuzz-14.2.1.tar.xz";
        hash = "sha256-pUpdjpOApB+7dizjZ7y/dwR5Lfyg2T8bvKhsWleQLg4=";
      };
    };
    "leptonica" = {
      file = "1.87.0.tar.gz";
      src = fetchurl {
        url = "https://github.com/DanBloomberg/leptonica/archive/refs/tags/1.87.0.tar.gz";
        hash = "sha256-+itAxcrqltG7k6l0hiYq7YcxtpziWoSmv10lMj4z9jE=";
      };
    };
    "libarchive" = {
      file = "libarchive-3.8.8.tar.xz";
      src = fetchurl {
        url = "https://github.com/libarchive/libarchive/releases/download/v3.8.8/libarchive-3.8.8.tar.xz";
        hash = "sha256-OHOoiAHaBn0FKKmJrwaHdxBSnVDuj+bzlwy7QwLvuRg=";
      };
    };
    "libjpeg-turbo" = {
      file = "libjpeg-turbo-3.2.0.tar.gz";
      src = fetchurl {
        url = "https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.2.0/libjpeg-turbo-3.2.0.tar.gz";
        hash = "sha256-bzAJLO+fuDl3lkZgj07hSuPLrJicR/oF6EGwhB8Jh44=";
      };
    };
    "libpng" = {
      file = "v1.6.58.tar.gz";
      src = fetchurl {
        url = "https://github.com/pnggroup/libpng/archive/refs/tags/v1.6.58.tar.gz";
        hash = "sha256-qdTfRj02puX5wpvW9JZzEtF+mWwYVPNRH4M5JOsZk88=";
      };
    };
    "libressl" = {
      file = "libressl-4.3.2.tar.gz";
      src = fetchurl {
        url = "https://cdn.openbsd.org/pub/OpenBSD/LibreSSL/libressl-4.3.2.tar.gz";
        hash = "sha256-7fAa7iTGXWnmqe/LnUS82mgv+dTzu72V55Th36kIR7U=";
      };
    };
    "libunibreak" = {
      file = "libunibreak-7.0.tar.gz";
      src = fetchurl {
        url = "https://github.com/adah1972/libunibreak/releases/download/libunibreak_7_0/libunibreak-7.0.tar.gz";
        hash = "sha256-jJpuEhc2zQ1ciQrjrpbz9AEKGaoEDx297YM6Yqh3F9M=";
      };
    };
    "libwebp" = {
      file = "libwebp-1.6.0.tar.gz";
      src = fetchurl {
        url = "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.6.0.tar.gz";
        hash = "sha256-5KtwCb8GKf0RmC1MKqg5ZM8kTP+6c0fs05AZqeOMRWQ=";
      };
    };
    "libzmq" = {
      file = "zeromq-4.3.5.tar.gz";
      src = fetchurl {
        url = "https://github.com/zeromq/libzmq/releases/download/v4.3.5/zeromq-4.3.5.tar.gz";
        hash = "sha256-ZlPvWRDxeVSGH+cjMuaLA8puTZxxYOs6jeWlqRO/q0M=";
      };
    };
    "lpeg" = {
      file = "v1.1.0.tar.gz";
      src = fetchurl {
        url = "https://github.com/roberto-ieru/LPeg/archive/refs/tags/v1.1.0.tar.gz";
        hash = "sha256-ibzVbGy30AHBL9LAxIbAbKgoP4tYmG9ZPWLMJuFFjeQ=";
      };
    };
    "luarocks" = {
      file = "v3.12.2.tar.gz";
      src = fetchurl {
        url = "https://github.com/luarocks/luarocks/archive/refs/tags/v3.12.2.tar.gz";
        hash = "sha256-nCX6erUBfWCyUTerGky3bjGF3x/gLfH1d/V9GmtUiio=";
      };
    };
    "md4c" = {
      file = "release-0.5.3.tar.gz";
      src = fetchurl {
        url = "https://github.com/mity/md4c/archive/refs/tags/release-0.5.3.tar.gz";
        hash = "sha256-NTw0bzdrh8lUoT80Fe3i1RJkzGHcWrzTj/HSqg0Fm54=";
      };
    };
    "miniconv" = {
      file = "170ddcb9ac8eda1e08e7426acecb6a5733cf1d36.tar.gz";
      src = fetchurl {
        url = "https://github.com/malord/miniconv/archive/170ddcb9ac8eda1e08e7426acecb6a5733cf1d36.tar.gz";
        hash = "sha256-9rXXvDyhLApmBLOCo9rT1/kCr0CZc7d8tvp1QAVhIbk=";
      };
    };
    "mupdf" = {
      file = "mupdf-1.27.2-source.tar.lz";
      src = fetchurl {
        url = "https://github.com/ArtifexSoftware/mupdf-downloads/releases/download/1.27.2/mupdf-1.27.2-source.tar.lz";
        hash = "sha256-NQSdzQsaVBvizKHrS71rQaUeDtRHmTM7e95FKEYeKEg=";
      };
    };
    # "openssh" -> excluded from the "all" target on Apple, same as "tar" above.
    "proxy-libintl" = {
      file = "0.4.tar.gz";
      src = fetchurl {
        url = "https://github.com/frida/proxy-libintl/archive/refs/tags/0.4.tar.gz";
        hash = "sha256-E+8+6go7wN9VKTvjaN+8/1qN1fR1koDyjgMNFJSl3/s=";
      };
    };
    "sdcv" = {
      file = "v0.5.5.tar.gz";
      src = fetchurl {
        url = "https://github.com/Dushistov/sdcv/archive/refs/tags/v0.5.5.tar.gz";
        hash = "sha256-TSUZ6PhHm5MB3JHpzaPh7v7xmXDs4OjAXwx7et5dyUs=";
      };
    };
    "sdl3" = {
      file = "SDL3-3.4.12.tar.gz";
      src = fetchurl {
        url = "https://github.com/libsdl-org/SDL/releases/download/release-3.4.12/SDL3-3.4.12.tar.gz";
        hash = "sha256-8HuViprFAg+3pEytuVf2WLIUnDyKu09jFF+skwMknbc=";
      };
    };
    "spec/busted" = {
      file = "busted-2.3.0-1.src.rock";
      src = fetchurl {
        url = "https://luarocks.org/manifests/lunarmodules/busted-2.3.0-1.src.rock";
        hash = "sha256-TavMIslhCg1yac/mgxjWjtmi2q7t3dwPaLhzr5iD5y4=";
      };
    };
    "spec/cluacov" = {
      file = "cluacov-0.1.4-1.src.rock";
      src = fetchurl {
        url = "https://luarocks.org/manifests/luarocks/cluacov-0.1.4-1.src.rock";
        hash = "sha256-4XBP6qP0Tqo6bd/uxaydP9qSjANwKjaAeEES28qzclY=";
      };
    };
    "spec/lua-term" = {
      file = "0.08.tar.gz";
      src = fetchurl {
        url = "https://github.com/hoelzro/lua-term/archive/0.08.tar.gz";
        hash = "sha256-j/lPOQ6p2YxzRpk3PKOwzlANZRsqscuNfSM2/Ft5ze0=";
      };
    };
    "spec/lua_cliargs" = {
      file = "v3.0.2.tar.gz";
      src = fetchurl {
        url = "https://github.com/lunarmodules/lua_cliargs/archive/refs/tags/v3.0.2.tar.gz";
        hash = "sha256-p6V6ucc/bEQECngwW23HeAyhVlzEyQV9dKZgjLBEOvQ=";
      };
    };
    "spec/luacov" = {
      file = "luacov-0.15.0-1.src.rock";
      src = fetchurl {
        url = "https://luarocks.org/manifests/hisham/luacov-0.15.0-1.src.rock";
        hash = "sha256-eEY0oDlmE0a/wyYzL7Nq0OSspkULeIUkl4eGKsxNx5M=";
      };
    };
    "spec/luafilesystem" = {
      file = "luafilesystem-1.9.0-1.src.rock";
      src = fetchurl {
        url = "https://luarocks.org/manifests/hisham/luafilesystem-1.9.0-1.src.rock";
        hash = "sha256-PeaNYZ9q2Von9HKIFDdUR9khMFGUtwUN7mGZBXwxKC8=";
      };
    };
    "spec/luassert" = {
      file = "luassert-1.9.0-1.src.rock";
      src = fetchurl {
        url = "https://luarocks.org/manifests/lunarmodules/luassert-1.9.0-1.src.rock";
        hash = "sha256-FGp7Lsjgyt99vKbcmT3rzSCQ4OT99cYy2fTsIGcDV90=";
      };
    };
    "spec/luasystem" = {
      file = "luasystem-0.7.1-1.src.rock";
      src = fetchurl {
        url = "https://luarocks.org/manifests/lunarmodules/luasystem-0.7.1-1.src.rock";
        hash = "sha256-jBF+xisiMzPYSUxd0hWL/7lyrHz1AayNDrDoViETg+0=";
      };
    };
    "spec/mediator_lua" = {
      file = "v1.1.2-0.tar.gz";
      src = fetchurl {
        url = "https://github.com/Olivine-Labs/mediator_lua/archive/v1.1.2-0.tar.gz";
        hash = "sha256-+vWFn9IIG+Tp5PuIc6LcZffv8/2T1t0U2mX44SP8/5s=";
      };
    };
    "spec/penlight" = {
      file = "penlight-1.15.0-1.src.rock";
      src = fetchurl {
        url = "https://luarocks.org/manifests/tieske/penlight-1.15.0-1.src.rock";
        hash = "sha256-uhOLi7yRb0Kttbh2xI0lQRT0FuiGeQL4w0/qJ4gUCXM=";
      };
    };
    "spec/say" = {
      file = "say-1.4.1-3.src.rock";
      src = fetchurl {
        url = "https://luarocks.org/manifests/lunarmodules/say-1.4.1-3.src.rock";
        hash = "sha256-kKHAJT7DjWYoAH7vC0JNBwfQ8+BEL85HimJxEesCuwc=";
      };
    };
    # "sqlite" -> vendored from nixpkgs' `sqlite` instead; see package.nix.
    # "tar" -> excluded from the "all" target on Apple (base/cmake/CMakeLists.txt); never built on Darwin.
    "tesseract" = {
      file = "5.5.2.tar.gz";
      src = fetchurl {
        url = "https://github.com/tesseract-ocr/tesseract/archive/refs/tags/5.5.2.tar.gz";
        hash = "sha256-YjXqDa5F6hN/WcCTIEBvWIg4N0GSTZiFW9LODRa1TyE=";
      };
    };
    "tree-sitter" = {
      file = "v0.26.10.tar.gz";
      src = fetchurl {
        url = "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.10.tar.gz";
        hash = "sha256-RQy4X9GvNBEesWLpMeDp5NTb8j/Am5y1b2KZoagEg7Y=";
      };
    };
    "tree-sitter-c" = {
      file = "v0.24.2.tar.gz";
      src = fetchurl {
        url = "https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v0.24.2.tar.gz";
        hash = "sha256-LutNsx+PoIZeRUiFA9E0A5I7y0haG9tjer/4xC3Zc2Q=";
      };
    };
    # "utf8proc" -> vendored from nixpkgs' `utf8proc` instead; see package.nix.
    # "xxhash" -> vendored from nixpkgs' `xxhash` instead; see package.nix.
    "xz" = {
      file = "xz-5.8.3.tar.xz";
      src = fetchurl {
        url = "https://github.com/tukaani-project/xz/releases/download/v5.8.3/xz-5.8.3.tar.xz";
        hash = "sha256-//H/zysNqE0wihTeUToaoj1OmqNGTRfmS5cUv90Lv7Y=";
      };
    };
    # "zlib" -> vendored from nixpkgs' `zlib` instead; see package.nix.
    "zstd" = {
      file = "zstd-1.5.7.tar.gz";
      src = fetchurl {
        url = "https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz";
        hash = "sha256-6zPlH0mhXgI5UM14Jcp0pKK0Pbg1SCWsJPwbfuCeb6M=";
      };
    };
  };

  git = {
    "djvulibre" = fetchgit {
      url = "https://gitlab.com/koreader/djvulibre.git";
      rev = "69e23da9876baa7fc052d6b2e03e62e3095ec2f1";
      sha256 = "sha256-Nh/f5dEWKPDnyRwAbXMQK/EOXD1TAtKgMdWBOLYuUfM=";
      fetchSubmodules = true;
    };
    "inkview" = fetchgit {
      url = "https://github.com/koreader/pocketbook-inkview.git";
      rev = "4a3e32c39ed14ac7f2e3ca4f8c66a7d5fbe5e0fe";
      sha256 = "sha256-J1vb3SO+GjFbvwLsPEHxMSVNttw4TV4BtMXL36oMEBc=";
      fetchSubmodules = true;
    };
    "kobo-usbms" = fetchgit {
      url = "https://github.com/koreader/KoboUSBMS.git";
      rev = "d1d916655b1406780f12ba0c2442b6a901e75929";
      sha256 = "sha256-EEENLGzdnDv5xH3nwxoZHDqESSRuS89klTyhAbTBl4Q=";
      fetchSubmodules = true;
    };
    "koreader-lfs" = fetchgit {
      url = "https://github.com/lunarmodules/luafilesystem";
      rev = "a186cca5833691e830ed255e38ace8ff6b870dbf";
      sha256 = "sha256-xoNJra/yqxRG11TePcUKrAUU6cwypGnXIoLKZXNaoW0=";
      fetchSubmodules = true;
    };
    "libk2pdfopt" = fetchgit {
      url = "https://github.com/koreader/libk2pdfopt.git";
      rev = "1fcffeb1e61ec43265d23e2ac77d9a901f8c45d2";
      sha256 = "sha256-T+ZZPcCaHA6+8+Y9ab3AuLN8PSxCFtRyJqTOl0h0Mis=";
      fetchSubmodules = true;
    };
    "lj-wpaclient" = fetchgit {
      url = "https://github.com/koreader/lj-wpaclient.git";
      rev = "0d5c8ee336b699dbb35850a7336d24e89e1aac24";
      sha256 = "sha256-RnDxYtuJVW0jDXOBjLhvk8wWI636kT9Tb8vYBMQOGj8=";
      fetchSubmodules = true;
    };
    "lodepng" = fetchgit {
      url = "https://github.com/lvandeve/lodepng.git";
      rev = "0b1d9ccfc2093e5d6620cd9a11d03ee6ff6705f5";
      sha256 = "sha256-bz8zOrpADnCHiVMA7bENhXj6pIu21pKQMNmhM6jOOvo=";
      fetchSubmodules = true;
    };
    "lua-Spore" = fetchgit {
      url = "https://framagit.org/fperrad/lua-Spore";
      rev = "f106f930e4fd6110f714dd89f8886e868c74a583";
      sha256 = "sha256-YiYLYSn0iJ2AyJjYKejrb2Ys93Dgz+4lTyXvkSL2Ljo=";
      fetchSubmodules = true;
    };
    "lua-htmlparser" = fetchgit {
      url = "https://github.com/msva/lua-htmlparser";
      rev = "5ce9a775a345cf458c0388d7288e246bb1b82bff";
      sha256 = "sha256-aSTLSfqz/MIDFVRwtBlDNBUhPb7KqOl32/Y62Hdec1s=";
      fetchSubmodules = true;
    };
    "lua-rapidjson" = fetchgit {
      url = "https://github.com/NiLuJe/lua-rapidjson";
      rev = "e84973356255bde06a70ce6263a3a0ef5c8f4ad4";
      sha256 = "sha256-SZ6iJ5J7k4vj9ubY5FNkcfgimWzvckNXeT3zTuDkJDU=";
      fetchSubmodules = true;
    };
    "luajit" = fetchgit {
      url = "https://github.com/LuaJIT/LuaJIT";
      rev = "3c4f9fe2052b8d08a917ac0d5f38563f0297b5a3";
      sha256 = "sha256-lEe/97aujbBWsnMjmatU5Ms+F9FDtqW4GM9zCvjFEqg=";
      fetchSubmodules = true;
    };
    "luajson" = fetchgit {
      url = "https://github.com/harningt/luajson.git";
      rev = "6ecaf9bea8b121a9ffca5a470a2080298557b55d";
      sha256 = "sha256-56G0NqIpavKHMQWUxy+Bp7G4ZKrQwUZ2C5e7GJxUJeg=";
      fetchSubmodules = true;
    };
    "luasec" = fetchgit {
      url = "https://github.com/brunoos/luasec";
      rev = "4c06287052d68fdbe7429b8f967cdc8ee94aa44a";
      sha256 = "sha256-o3uiZQnn/ID1qAgpZAqA4R3fWWk+Ajcgx++iNu1yLWc=";
      fetchSubmodules = true;
    };
    "luasocket" = fetchgit {
      url = "https://github.com/lunarmodules/luasocket";
      rev = "e3ca4a767a68d127df548d82669aba3689bd84f4";
      sha256 = "sha256-RWNJmezZvqZ36XTqTOf5hKbD+mreis62KFNlJRr5Q8o=";
      fetchSubmodules = true;
    };
    "lunasvg" = fetchgit {
      url = "https://github.com/sammycage/lunasvg.git";
      rev = "610b8bf5148a27489b4e3344b4f5617b81be38c7";
      sha256 = "sha256-A/ONhRQ+NVw3tVlKq8HEz/wMSH+xT5WJO3w6wdH/2jc=";
      fetchSubmodules = true;
    };
    "minizip" = fetchgit {
      url = "https://github.com/nmoinvaz/minizip";
      rev = "aa4758baea16e9dc03583340e62b370ea1140df9";
      sha256 = "sha256-OIBxGG4ehVjjr7QkSWXJtM0kblIGJtQP2MHajw7J8PM=";
      fetchSubmodules = true;
    };
    "nanosvg" = fetchgit {
      url = "https://github.com/memononen/nanosvg.git";
      rev = "ea6a6aca009422bba0dbad4c80df6e6ba0c82183";
      sha256 = "sha256-QCjfaSm1/hstVGzkJc0gFnYhnU5I3oHSCTkAVG5gTt8=";
      fetchSubmodules = true;
    };
    "openlipclua" = fetchgit {
      url = "https://github.com/notmarek/openlipclua.git";
      rev = "96c2d16696a482664b4e84eb3b6d851f807a44d1";
      sha256 = "sha256-6H9iyO25AOFU4u9jdaxGtsAxeYXKdJFz6LzzatTFblg=";
      fetchSubmodules = true;
    };
    "popen-noshell" = fetchgit {
      url = "https://github.com/famzah/popen-noshell.git";
      rev = "e715396a4951ee91c40a98d2824a130f158268bb";
      sha256 = "sha256-JeBZMsg6ZUGSnyZ4eds4w63gM/L73EsAnLaHOPpL6iM=";
      fetchSubmodules = true;
    };
    "turbo" = fetchgit {
      url = "https://github.com/kernelsauce/turbo";
      rev = "7fe88c2b99ff9bd6d6df3ee3c4077ea8a7d1e6a3";
      sha256 = "sha256-vBRkFdc5a0FIt15HBz3TnqMZ+GGsqjEefnfJEpuVTBs=";
      fetchSubmodules = true;
    };
    "zsync2" = fetchgit {
      url = "https://github.com/NiLuJe/zsync2.git";
      rev = "e281e1eb4466ff6b3866c25dbe62a3e150fa5bfd";
      sha256 = "sha256-guZo3icFzCl6fMv6jlol2+HRfBlZlLfaFVrE8uQNpDA=";
      fetchSubmodules = true;
    };
  };
}
