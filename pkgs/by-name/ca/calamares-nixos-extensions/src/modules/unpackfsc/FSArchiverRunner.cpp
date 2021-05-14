/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#include "Runners.h"

Calamares::JobResult FSArchiverRunner::run()
{
    if (!checkSourceExists())
    {
        return Calamares::JobResult::internalError(
            tr( "Invalid fsarchiver configuration" ),
                                                   tr( "The source archive <i>%1</i> does not exist." ).arg(m_source),
                                                   Calamares::JobResult::InvalidConfiguration );
    }

    return Calamares::JobResult::ok();
}
