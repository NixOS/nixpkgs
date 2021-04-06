/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#include "UnpackFSCJob.h"

UnpackFSCJob::UnpackFSCJob( QObject* parent )
    : Calamares::CppJob( parent )
{
}

UnpackFSCJob::~UnpackFSCJob() {}

QString
UnpackFSCJob::prettyName() const
{
    return tr( "Unpack filesystems" );
}

Calamares::JobResult
UnpackFSCJob::exec()
{
    return Calamares::JobResult::ok();
}

void
UnpackFSCJob::setConfigurationMap( const QVariantMap& configurationMap )
{
    m_config.setConfigurationMap( configurationMap );
}

CALAMARES_PLUGIN_FACTORY_DEFINITION( UnpackFSCFactory, registerPlugin< UnpackFSCJob >(); )
