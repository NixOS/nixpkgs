const PR_SIZE_THRESHOLDS = [
  {
    label: '7.size: XS',
    maxChangedLines: 10,
    maxChangedFiles: 1,
  },
  {
    label: '7.size: S',
    maxChangedLines: 50,
    maxChangedFiles: 3,
  },
  {
    label: '7.size: M',
    maxChangedLines: 200,
    maxChangedFiles: 10,
  },
  {
    label: '7.size: L',
    maxChangedLines: 1000,
    maxChangedFiles: 50,
  },
  {
    label: '7.size: XL',
    maxChangedLines: Infinity,
    maxChangedFiles: Infinity,
  },
]

const PR_SIZE_LABELS = PR_SIZE_THRESHOLDS.map(({ label }) => label)

function classifyPullRequestSize({ additions, deletions, changedFiles }) {
  // GitHub reports a modified line as both an addition and a deletion.
  const changedLines = additions + deletions

  // A PR belongs to the first tier whose line and file limits both contain it.
  return PR_SIZE_THRESHOLDS.find(
    ({ maxChangedLines, maxChangedFiles }) =>
      changedLines <= maxChangedLines && changedFiles <= maxChangedFiles,
  ).label
}

module.exports = {
  PR_SIZE_LABELS,
  classifyPullRequestSize,
}
