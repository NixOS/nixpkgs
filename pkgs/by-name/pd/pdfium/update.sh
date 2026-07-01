#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash coreutils curl git gnused nix

set -euo pipefail

script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd -P)
repo_root=$(git -C "$script_dir" rev-parse --show-toplevel)
package_file="$script_dir/package.nix"
chromium_git_url="https://chromium.googlesource.com"

cd "$repo_root"

current_version=$(
  nix-instantiate --eval -E 'with import ./. {}; pdfium.version' | tr -d '"'
)

resolve_latest_version() {
  git ls-remote --refs https://pdfium.googlesource.com/pdfium 'refs/heads/chromium/*' \
    | awk -F/ '/refs\/heads\/chromium\/[0-9]+$/ { print $NF }' \
    | sort -n \
    | tail -1
}

target_version=${1:-$(resolve_latest_version)}

to_sri() {
  nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$1"
}

prefetch_hash() {
  local url=$1
  nix-prefetch-url --unpack "$url" 2>/dev/null
}

prefetch_file() {
  local url=$1
  mapfile -t prefetched < <(nix-prefetch-url --print-path "$url" 2>/dev/null)
  if [[ ${#prefetched[@]} -ne 2 ]]; then
    echo "unexpected nix-prefetch-url output for $url" >&2
    exit 1
  fi
  printf '%s\n' "${prefetched[@]}"
}

prefetch_subdir_archive_hash() {
  local url=$1
  local tmp
  local hash
  tmp=$(mktemp -d)
  mapfile -t prefetched < <(prefetch_file "$url")
  # Gitiles subdirectory archives here do not hash correctly via
  # `nix-prefetch-url --unpack`, so hash the extracted tree directly.
  tar -xzf "${prefetched[1]}" -C "$tmp"
  hash=$(nix --extra-experimental-features nix-command hash path "$tmp")
  rm -rf "$tmp"
  printf '%s\n' "$hash"
}

prefetch_unpack() {
  local url=$1
  mapfile -t prefetched < <(nix-prefetch-url --unpack --print-path "$url")
  if [[ ${#prefetched[@]} -ne 2 ]]; then
    echo "unexpected nix-prefetch-url output for $url" >&2
    exit 1
  fi
  printf '%s\n' "${prefetched[@]}"
}

extract_deps_rev() {
  local deps_file=$1
  local key=$2
  sed -n "s/^  '${key}': '\\([0-9a-f]\\+\\)',$/\\1/p" "$deps_file"
}

set_string_var() {
  local name=$1
  local value=$2
  sed -i -E "s|^  ${name} = \".*\";|  ${name} = \"${value}\";|" "$package_file"
}

set_int_var() {
  local name=$1
  local value=$2
  sed -i -E "s|^    ${name} = [0-9]+;|    ${name} = ${value};|" "$package_file"
}

echo "current build: $current_version"
echo "target  build: $target_version"

pdfium_url="https://pdfium.googlesource.com/pdfium/+archive/refs/heads/chromium/${target_version}.tar.gz"
mapfile -t pdfium_prefetch < <(prefetch_unpack "$pdfium_url")
pdfium_hash=$(to_sri "${pdfium_prefetch[0]}")
pdfium_src=${pdfium_prefetch[1]}

deps_file="$pdfium_src/DEPS"
build_rev=$(extract_deps_rev "$deps_file" build_revision)
abseil_rev=$(extract_deps_rev "$deps_file" abseil_revision)
dragonbox_rev=$(extract_deps_rev "$deps_file" dragonbox_revision)
fast_float_rev=$(extract_deps_rev "$deps_file" fast_float_revision)
fp16_rev=$(extract_deps_rev "$deps_file" fp16_revision)
gtest_rev=$(extract_deps_rev "$deps_file" gtest_revision)
highway_rev=$(extract_deps_rev "$deps_file" highway_revision)
libcxx_rev=$(extract_deps_rev "$deps_file" libcxx_revision)
libcxxabi_rev=$(extract_deps_rev "$deps_file" libcxxabi_revision)
llvm_libc_rev=$(extract_deps_rev "$deps_file" llvm_libc_revision)
test_fonts_rev=$(extract_deps_rev "$deps_file" test_fonts_revision)
v8_rev=$(extract_deps_rev "$deps_file" v8_revision)
zlib_rev=$(extract_deps_rev "$deps_file" zlib_revision)
simdutf_rev=$(extract_deps_rev "$deps_file" simdutf_revision)

for dep_var in build_rev abseil_rev dragonbox_rev fast_float_rev fp16_rev gtest_rev highway_rev libcxx_rev libcxxabi_rev llvm_libc_rev test_fonts_rev v8_rev zlib_rev simdutf_rev; do
  if [[ -z ${!dep_var} ]]; then
    echo "failed to extract $dep_var from $deps_file" >&2
    exit 1
  fi
done

chromium_version=$(
  curl -sSfL "${chromium_git_url}/chromium/src/+/refs/branch-heads/${target_version}/chrome/VERSION?format=TEXT" \
    | base64 -d
)
major=$(printf '%s\n' "$chromium_version" | sed -n 's/^MAJOR=//p')
minor=$(printf '%s\n' "$chromium_version" | sed -n 's/^MINOR=//p')
build=$(printf '%s\n' "$chromium_version" | sed -n 's/^BUILD=//p')
patch=$(printf '%s\n' "$chromium_version" | sed -n 's/^PATCH=//p')

for version_var in major minor build patch; do
  if [[ -z ${!version_var} ]]; then
    echo "failed to extract $version_var from Chromium chrome/VERSION" >&2
    exit 1
  fi
done

build_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/chromium/src/build.git/+archive/${build_rev}.tar.gz")")
chromium_buildtools_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/chromium/src/+archive/refs/branch-heads/${target_version}/buildtools.tar.gz")")
abseil_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/chromium/src/third_party/abseil-cpp/+archive/${abseil_rev}.tar.gz")")
dragonbox_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/external/github.com/jk-jeon/dragonbox.git/+archive/${dragonbox_rev}.tar.gz")")
fast_float_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/external/github.com/fastfloat/fast_float/+archive/${fast_float_rev}.tar.gz")")
fp16_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/external/github.com/Maratyszcza/FP16/+archive/${fp16_rev}.tar.gz")")
gtest_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/external/github.com/google/googletest/+archive/${gtest_rev}.tar.gz")")
highway_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/external/github.com/google/highway.git/+archive/${highway_rev}.tar.gz")")
libcxx_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/external/github.com/llvm/llvm-project/libcxx.git/+archive/${libcxx_rev}.tar.gz")")
libcxxabi_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/external/github.com/llvm/llvm-project/libcxxabi.git/+archive/${libcxxabi_rev}.tar.gz")")
llvm_libc_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/external/github.com/llvm/llvm-project/libc.git/+archive/${llvm_libc_rev}.tar.gz")")
generate_shim_headers_hash=$(prefetch_subdir_archive_hash "${chromium_git_url}/chromium/src/+archive/refs/branch-heads/${target_version}/tools/generate_shim_headers.tar.gz")
test_fonts_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/chromium/src/third_party/test_fonts/+archive/${test_fonts_rev}.tar.gz")")
test_fonts_bundle_object=$(
  curl -sSfL "${chromium_git_url}/chromium/src/third_party/test_fonts/+/${test_fonts_rev}/test_fonts.tar.gz.sha1?format=TEXT" \
    | base64 -d \
    | tr -d '\n'
)
if [[ -z $test_fonts_bundle_object ]]; then
  echo "failed to extract test_fonts_bundle_object from Chromium test_fonts repo" >&2
  exit 1
fi
mapfile -t test_fonts_bundle_prefetch < <(prefetch_file "https://storage.googleapis.com/chromium-fonts/${test_fonts_bundle_object}")
test_fonts_bundle_hash=$(to_sri "${test_fonts_bundle_prefetch[0]}")
v8_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/v8/v8/+archive/${v8_rev}.tar.gz")")
zlib_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/chromium/src/third_party/zlib/+archive/${zlib_rev}.tar.gz")")
simdutf_hash=$(to_sri "$(prefetch_hash "${chromium_git_url}/chromium/src/third_party/simdutf/+archive/${simdutf_rev}.tar.gz")")

set_int_var major "$major"
set_int_var minor "$minor"
set_int_var build "$build"
set_int_var patch "$patch"

set_string_var pdfiumHash "$pdfium_hash"
set_string_var buildRev "$build_rev"
set_string_var buildHash "$build_hash"
set_string_var chromiumBuildtoolsHash "$chromium_buildtools_hash"
set_string_var abseilRev "$abseil_rev"
set_string_var abseilHash "$abseil_hash"
set_string_var dragonboxRev "$dragonbox_rev"
set_string_var dragonboxHash "$dragonbox_hash"
set_string_var fastFloatRev "$fast_float_rev"
set_string_var fastFloatHash "$fast_float_hash"
set_string_var fp16Rev "$fp16_rev"
set_string_var fp16Hash "$fp16_hash"
set_string_var gtestRev "$gtest_rev"
set_string_var gtestHash "$gtest_hash"
set_string_var highwayRev "$highway_rev"
set_string_var highwayHash "$highway_hash"
set_string_var libcxxRev "$libcxx_rev"
set_string_var libcxxHash "$libcxx_hash"
set_string_var libcxxabiRev "$libcxxabi_rev"
set_string_var libcxxabiHash "$libcxxabi_hash"
set_string_var llvmLibcRev "$llvm_libc_rev"
set_string_var llvmLibcHash "$llvm_libc_hash"
set_string_var generateShimHeadersHash "$generate_shim_headers_hash"
set_string_var testFontsRev "$test_fonts_rev"
set_string_var testFontsHash "$test_fonts_hash"
set_string_var testFontsBundleObject "$test_fonts_bundle_object"
set_string_var testFontsBundleHash "$test_fonts_bundle_hash"
set_string_var v8Rev "$v8_rev"
set_string_var v8Hash "$v8_hash"
set_string_var zlibRev "$zlib_rev"
set_string_var zlibHash "$zlib_hash"
set_string_var simdutfRev "$simdutf_rev"
set_string_var simdutfHash "$simdutf_hash"

echo "updated $package_file"
