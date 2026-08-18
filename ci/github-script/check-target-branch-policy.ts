const { classify, split } = require('../supportedBranches.js')

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
  const isPrimaryBase = baseClassification.type.includes('primary')
  const isPrimaryHead = headClassification.type.includes('primary')
  const isStagingNixosBase = split(base).prefix === 'staging-nixos'
  const isDevelopmentHead = headClassification.type.includes('development')
  const shouldSkipDevelopmentMerge =
    isDevelopmentHead && (!isStagingNixosBase || isPrimaryHead)

  return {
    isStagingNixosBase,
    shouldSkipDevelopmentMerge,
    shouldCheckMassRebuild:
      !shouldSkipDevelopmentMerge && (isPrimaryBase || isStagingNixosBase),
    shouldCheckNixosRebuild: !shouldSkipDevelopmentMerge && isPrimaryBase,
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
  const {
    isStagingNixosBase,
    shouldSkipDevelopmentMerge,
    shouldCheckMassRebuild,
    shouldCheckNixosRebuild,
  } = getTargetBranchPolicy({ base, head })
  const isMassRebuild =
    maxRebuildCount >= 1000 &&
    !isExemptKernelUpdate &&
    !isExemptHomeAssistantUpdate

  if (shouldCheckMassRebuild && isMassRebuild) {
    return 'mass-rebuild'
  }

  if (shouldCheckNixosRebuild && rebuildsAllTests && !isExemptKernelUpdate) {
    return 'nixos-rebuild'
  }

  const isPossibleMassRebuild =
    maxRebuildCount >= 500 &&
    !isMassRebuild &&
    !isExemptKernelUpdate &&
    !isExemptHomeAssistantUpdate
  if (
    shouldCheckMassRebuild &&
    isPossibleMassRebuild &&
    !(rebuildsAllTests && isStagingNixosBase)
  ) {
    return 'possible-mass-rebuild'
  }

  return shouldSkipDevelopmentMerge ? 'skip-development-merge' : 'dismiss'
}

module.exports = { decideTargetBranchReview, getTargetBranchPolicy }
