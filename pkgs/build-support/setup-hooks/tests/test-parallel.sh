export NIX_BUILD_CORES=4

echo "Testing worker distribution..."

# Generate 100 jobs to ensure all workers get some
for i in {1..100}; do
  printf "job%d\0" $i
done | parallelRun sh -c '
  while IFS= read -r -d "" job; do
    sleep 0.05  # Simulate some work
    echo "Worker $$ processed $job" >> /tmp/worker-output
  done
'

# Check that all 4 workers were actually utilized
worker_count=$(sort /tmp/worker-output | cut -d" " -f2 | sort -u | wc -l)
if [ "$worker_count" -ne 4 ]; then
  echo "ERROR: Expected exactly 4 workers, got $worker_count"
  cat /tmp/worker-output
  exit 1
fi
echo "SUCCESS: All 4 workers participated"
rm -f /tmp/worker-output

echo "Testing error propagation..."

# Test that errors from workers are propagated
if printf "job1\0job2\0job3\0" | parallelRun sh -c '
  while IFS= read -r -d "" job; do
    if [ "$job" = "job2" ]; then
      echo "Worker failing on $job" >&2
      exit 1
    fi
    echo "Worker processed $job"
  done
' 2>/dev/null; then
  echo "ERROR: Expected command to fail but it succeeded"
  exit 1
else
  echo "SUCCESS: Error was properly propagated"
fi

echo "Testing error message..."

error_output=$(printf "job1\0job2\0job3\0" | parallelRun sh -c '
  while IFS= read -r -d "" job; do
    if [ "$job" = "job2" ]; then
      echo "Worker failing on $job" >&2
      exit 1
    fi
    echo "Worker processed $job"
  done
' 2>&1 || true)

if [[ "$error_output" != *"job failed"* ]]; then
  echo "ERROR: Expected 'job failed' in error message, got: $error_output"
  exit 1
fi
echo "SUCCESS: Error message was displayed"

echo "Testing Verify all jobs are processed when no errors occur..."

# Generate jobs and count processed ones
for i in {1..10}; do
  printf "job%d\0" $i
done | parallelRun sh -c '
  while IFS= read -r -d "" job; do
    echo "$job" >> /tmp/processed-jobs
  done
'

processed_count=$(wc -l < /tmp/processed-jobs)
if [ "$processed_count" -ne 10 ]; then
  echo "ERROR: Expected 10 jobs processed, got $processed_count"
  exit 1
fi
echo "SUCCESS: All 10 jobs were processed"
rm -f /tmp/processed-jobs

echo "All parallelRun tests passed!"

# ---------------------------------------------------------------------

echo "Testing parallelMap basic functionality..."

# Define a test function
testFunc() {
  echo "Processing: $1" >> /tmp/map-output
}

# Test that parallelMap calls the function with each job
for i in {1..5}; do
  printf "item%d\0" $i
done | parallelMap testFunc

# Check all jobs were processed
processed_map_count=$(wc -l < /tmp/map-output)
if [ "$processed_map_count" -ne 5 ]; then
  echo "ERROR: Expected 5 items processed by parallelMap, got $processed_map_count"
  exit 1
fi
echo "SUCCESS: parallelMap processed all 5 items"
rm -f /tmp/map-output

echo "Testing parallelMap error propagation..."

# Define a function that fails on specific input
failFunc() {
  if [ "$1" = "item2" ]; then
    echo "Function failing on $1" >&2
    exit 1
  fi
  echo "Function processed $1"
}

# Test that errors are propagated
if printf "item1\0item2\0item3\0" | parallelMap failFunc 2>/dev/null; then
  echo "ERROR: Expected parallelMap to fail but it succeeded"
  exit 1
else
  echo "SUCCESS: parallelMap error was properly propagated"
fi

echo "Testing parallelMap with additional arguments..."

# Define a function that uses additional arguments
argFunc() {
  echo "$1: $2" >> /tmp/map-args-output
}

# Test with additional arguments
for i in {1..3}; do
  printf "value%d\0" $i
done | parallelMap argFunc "PREFIX"

# Check output contains the prefix
if ! grep -q "PREFIX: value1" /tmp/map-args-output; then
  echo "ERROR: parallelMap did not pass additional arguments correctly"
  cat /tmp/map-args-output
  exit 1
fi
echo "SUCCESS: parallelMap passed additional arguments correctly"
rm -f /tmp/map-args-output

echo "All parallelRun and parallelMap tests passed!"
touch $out
