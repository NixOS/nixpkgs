for x in ${extraBefore+"${extraBefore[@]}"} \
           ${params+"${params[@]}"} \
           ${extraAfter+"${extraAfter[@]}"}; do
  if [[ $x == --high-entropy-va ]]; then
    echo "ld-wrapper: --high-entropy-va will cause instability on cygwin" >&2
    exit 1
  fi
done
