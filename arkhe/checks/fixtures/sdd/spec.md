# Requirements

### Requirement 1

**User Story:** As a user, I want MFA, so that my account is safe.

#### Acceptance Criteria

1. WHEN a user submits valid credentials THEN the system SHALL require a second factor
2. IF the second factor is wrong three times, THE system SHALL lock the account
3. THE system SHALL NOT store the second factor in plain text

### Requirement 2

1. WHILE the account is locked, WHEN the user requests a reset, THE system SHALL send a recovery email
