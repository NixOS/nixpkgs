#!/usr/bin/env bash
set -x

# Package paths (substituted by Nix)
coreutils="@coreutils@"
imagemagick="@imagemagick@"
ghostscript="@ghostscript@"

# Add coreutils to PATH to avoid repetition
PATH="$coreutils/bin:$PATH"

# Configuration (substituted by Nix)
destDir="@outputDirectory@"
scanner_bin="@scannerBinary@"
scan_source="@scanSource@"
scan_mode="@scanMode@"
scan_resolution="@scanResolution@"
pdf_density="@pdfDensity@"
pdf_compression="@pdfCompression@"
pdf_settings="@pdfSettings@"

scan_document() {
  local tmpdir="$1"
  local scanner_bin="$2"
  local source="$3"
  local mode="$4"
  local resolution="$5"

  pushd "$tmpdir" || return

  # Detect scanner binary type by basename
  local bin_name
  bin_name="$(basename "$scanner_bin")"

  case "$bin_name" in
    scanadf)
      # scanadf automatically scans all pages in ADF and creates numbered files
      "$scanner_bin" \
        -d "$SCANBD_DEVICE" \
        --source "$source" \
        --mode "$mode" \
        --resolution "$resolution"
      ;;
    scanimage)
      # scanimage needs --batch mode for multiple pages
      # Uses format string for output file naming
      "$scanner_bin" \
        -d "$SCANBD_DEVICE" \
        --source "$source" \
        --mode "$mode" \
        --resolution "$resolution" \
        --batch=image-%04d.pnm \
        --batch-start 1 \
        --format=pnm
      ;;
    *)
      # Unknown scanner binary - try scanadf-style invocation
      echo "Warning: Unknown scanner binary '$bin_name', assuming scanadf-compatible interface"
      "$scanner_bin" \
        -d "$SCANBD_DEVICE" \
        --source "$source" \
        --mode "$mode" \
        --resolution "$resolution"
      ;;
  esac

  popd || return
}

convert_to_pdf() {
  local tmpdir="$1"
  local output="$2"
  local density="$3"
  local compression="$4"

  pushd "$tmpdir" || return
  # Convert PNM images to PDF
  "$imagemagick/bin/convert" image* \
    -density "$density" \
    -compress "$compression" \
    "$output"
  popd || return
}

compress_pdf() {
  local input="$1"
  local output="$2"
  local settings="$3"

  # Use ghostscript to reduce filesize
  "$ghostscript/bin/gs" \
    -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.4 \
    -dPDFSETTINGS="$settings" \
    -dNOPAUSE \
    -dQUIET \
    -dBATCH \
    -sOutputFile="$output" \
    "$input"
}

atomic_move() {
  local src="$1"
  local destDir="$2"
  local basename
  basename="$(basename "$src")"

  # Atomic move to destination
  cp -pv "$src" "$destDir/$basename.tmp"
  mv "$destDir/$basename.tmp" "$destDir/$basename"
}

cleanup() {
  local tmpdir="$1"
  local prelim_file="$2"

  rm --verbose "$tmpdir"/image* "$tmpdir/$prelim_file"
  rm -r "$tmpdir"
}

main() {
  # Setup
  local date
  date="$(date --iso-8601=seconds)"
  local prelim_filename="Prelim $date.pdf"
  local filename="Scan $date.pdf"
  local tmpdir
  tmpdir="$(mktemp -d)"

  # Execution
  scan_document "$tmpdir" "$scanner_bin" "$scan_source" "$scan_mode" "$scan_resolution"

  # Check if any images were scanned
  local image_count
  image_count=$(find "$tmpdir" -name 'image*' -type f | wc -l)

  if [ "$image_count" -eq 0 ]; then
    echo "No pages scanned - ADF may be empty"
    rm -r "$tmpdir"
    return 0
  fi

  convert_to_pdf "$tmpdir" "$prelim_filename" "$pdf_density" "$pdf_compression"
  compress_pdf "$tmpdir/$prelim_filename" "$tmpdir/$filename" "$pdf_settings"

  chmod 0666 "$tmpdir/$filename"

  atomic_move "$tmpdir/$filename" "$destDir"
  cleanup "$tmpdir" "$prelim_filename"
}

main
