/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#ifndef UNPACKFSC_FSARCHIVERRUNNER_H
#define UNPACKFSC_FSARCHIVERRUNNER_H

#include "Runners.h"

class FSArchiverRunner : public Runner
{
    Q_OBJECT
public:
    using Runner::Runner;

    Calamares::JobResult run() override;

protected Q_SLOTS:
    void fsarchiverProgress( QString line );

private:
    int m_since = 0;
};

#endif
