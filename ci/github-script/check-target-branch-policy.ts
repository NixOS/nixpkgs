const { classify } = require('../supportedBranches.js')

type TargetBranchPolicyFacts = {
  base: string
  head: string
  maxRebuildCount: number
  rebuildsAllTests: boolean
  isExemptKernelUpdate: boolean
  isExemptHomeAssistantUpdate: boolean
}

type TargetBranchReviewDecision =
  | 'mass-rebuild'
  | 'nixos-rebuild'
  | 'possible-mass-rebuild'
  | 'skip-development-merge'
  | 'dismiss'

function getTargetBranchPolicy({ base, head }: { base: string; head: string }) {
  const baseClassification = classify(base)
  const headClassification = classify(head)

  return {
    shouldSkipDevelopmentMerge: headClassification.type.includes('development'),
    shouldCheckMassRebuild: baseClassification.type.includes('primary'),
  }
}

function decideTargetBranchReview({
  base,
  head,
  maxRebuildCount,
  rebuildsAllTests,
  isExemptKernelUpdate,
  isExemptHomeAssistantUpdate,
}: TargetBranchPolicyFacts): TargetBranchReviewDecision {
  const baseClassification = classify(base)
  const headClassification = classify(head)

  if (headClassification.type.includes('development')) {
    return 'skip-development-merge'
  }

  if (!baseClassification.type.includes('primary')) {
    return 'dismiss'
  }

  if (
    maxRebuildCount >= 1000 &&
    !isExemptHomeAssistantUpdate &&
    !isExemptKernelUpdate
  ) {
    return 'mass-rebuild'
  } else if (rebuildsAllTests && !isExemptKernelUpdate) {
    return 'nixos-rebuild'
  } else if (
    maxRebuildCount >= 500 &&
    !isExemptKernelUpdate &&
    !isExemptHomeAssistantUpdate
  ) {
    return 'possible-mass-rebuild'
  } else {
    return 'dismiss'
  }
}

module.exports = { decideTargetBranchReview, getTargetBranchPolicy }
